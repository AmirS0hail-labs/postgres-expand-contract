import { Controller } from "@hotwired/stimulus"

const BEAT_MS = 1500
const GLIDE_MS = 1200

export default class extends Controller {
  static targets = [
    "flow", "token", "oldPhone", "primaryPhone", "extraPhone", "extraRow",
    "oldLen", "primaryLen", "extraLen",
    "forward", "back", "flag", "flagValue",
    "beat", "secondaryBeat", "emptyBeat", "play"
  ]

  static values = {
    phone: String,
    copied: String,
    mode: String
  }

  connect() {
    this.reduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches
    this.generation = 0
    if (this.modeValue === "primary") this.playPrimary()
    if (this.modeValue === "secondary") this.playSecondary()
  }

  disconnect() {
    this.stop()
  }

  play() {
    this.playPrimary()
  }

  async playPrimary() {
    this.stop()
    const generation = this.generation
    this.prepare("primary")
    this.press()
    this.writePhones()

    if (this.phoneValue === "") {
      this.showEmpty()
      return
    }

    if (this.reduced) {
      this.finishPrimary()
      return
    }

    this.revealBeat(0)
    this.oldPhoneTarget.classList.add("lit")
    this.oldLenTarget.classList.add("lit")
    this.tokenTarget.classList.remove("is-extra")
    this.tokenTarget.textContent = this.phoneValue
    this.snap(this.oldPhoneTarget)
    if (!await this.wait(BEAT_MS, generation)) return

    this.revealBeat(1)
    this.forwardTarget.classList.add("is-hot")
    if (!await this.glideAndLand(this.primaryPhoneTarget, generation)) return
    this.markMatched()
    if (!await this.wait(BEAT_MS, generation)) return

    this.revealBeat(2)
    this.raiseFlag()
    this.hideToken()
    this.keepInView(this.beatTargets[2])
    if (!await this.wait(BEAT_MS, generation)) return
  }

  finishPrimary() {
    this.writePhones()
    this.markMatched()
    this.forwardTarget.classList.add("is-hot")
    this.raiseFlag()
    this.beatTargets.forEach((beat) => {
      beat.hidden = false
      beat.classList.add("is-current")
    })
    this.keepInView(this.beatTargets[this.beatTargets.length - 1])
    this.hideToken()
  }

  async playSecondary() {
    this.stop()
    const generation = this.generation
    this.prepare("secondary")
    this.press()
    this.writePhones()
    this.beatTargets.forEach((beat) => {
      beat.hidden = true
    })
    if (this.hasSecondaryBeatTarget) {
      this.secondaryBeatTarget.hidden = false
      this.keepInView(this.secondaryBeatTarget)
    }
    this.oldPhoneTarget.classList.add("is-steady")
    this.backTarget.classList.add("is-stopped")

    const row = this.pendingRow()
    if (this.reduced) {
      this.revealExtra(row)
      this.hideToken()
      return
    }

    requestAnimationFrame(() => this.revealExtra(row))
    await this.wait(BEAT_MS, generation)
  }

  showEmpty() {
    this.beatTargets.forEach((beat) => {
      beat.hidden = true
    })
    if (this.hasEmptyBeatTarget) {
      this.emptyBeatTarget.hidden = false
      this.keepInView(this.emptyBeatTarget)
    }
    this.hideToken()
  }

  prepare(mode) {
    this.application.controllers
      .filter((controller) => controller !== this && controller.identifier === "person-flow")
      .forEach((controller) => controller.quiet())
    this.flowTarget.hidden = false
    this.resetPath()
    if (mode === "primary") {
      this.extraRowTargets.forEach((row) => row.classList.remove("is-pending"))
    }
    this.revealOpenedFlow()
  }

  quiet() {
    this.stop()
    if (this.hasFlowTarget) this.flowTarget.hidden = true
  }

  writePhones() {
    const phone = this.phoneValue
    const copied = this.hasCopiedValue ? this.copiedValue : phone
    this.oldPhoneTarget.textContent = phone
    this.oldLenTarget.textContent = String(phone.length)
    this.primaryPhoneTarget.textContent = copied
    this.primaryLenTarget.textContent = String(copied.length)
  }

  markMatched() {
    this.oldPhoneTarget.classList.add("lit")
    this.primaryPhoneTarget.classList.add("lit")
    this.oldLenTarget.classList.add("lit")
    this.primaryLenTarget.classList.add("lit")
  }

  revealBeat(index) {
    this.beatTargets.forEach((beat, beatIndex) => {
      if (beatIndex > index) return
      beat.hidden = false
      beat.classList.toggle("is-current", beatIndex === index)
      beat.classList.toggle("is-done", beatIndex < index)
    })
    this.keepInView(this.beatTargets[index])
  }

  pendingRow() {
    return this.extraRowTargets.find((row) => row.classList.contains("is-pending"))
  }

  revealExtra(row) {
    if (!row) return
    row.classList.remove("is-pending")
    const chip = row.querySelector("[data-person-flow-target='extraPhone']")
    if (chip) this.markLanded(chip)
  }

  raiseFlag() {
    this.flagValueTarget.textContent = "'1'"
    this.flagTarget.classList.add("is-on")
    this.backTarget.classList.add("is-stopped")
  }

  resetPath() {
    this.tokenTarget.classList.remove("is-moving", "is-extra")
    this.flowTarget.querySelectorAll(".lit, .landed, .is-steady").forEach((el) => {
      el.classList.remove("lit", "landed", "is-steady")
    })
    this.forwardTarget.classList.remove("is-hot")
    this.backTarget.classList.remove("is-stopped")
    delete this.backTarget.dataset.stop
    this.flagTarget.classList.remove("is-on")
    this.flagValueTarget.textContent = "'0'"
    this.beatTargets.forEach((beat) => {
      beat.hidden = true
      beat.classList.remove("is-current", "is-done")
    })
    if (this.hasSecondaryBeatTarget) this.secondaryBeatTarget.hidden = true
    if (this.hasEmptyBeatTarget) this.emptyBeatTarget.hidden = true
  }

  revealOpenedFlow() {
    requestAnimationFrame(() => this.keepInView(this.flowTarget))
  }

  keepInView(el) {
    if (!el) return
    el.scrollIntoView({ block: "nearest", behavior: "auto" })
  }

  press() {
    if (this.hasPlayTarget) this.playTarget.setAttribute("aria-pressed", "true")
  }

  snap(el) {
    this.tokenTarget.hidden = false
    this.tokenTarget.classList.remove("is-moving")
    this.tokenTarget.classList.add("no-move")
    this.move(el, false)
    this.tokenTarget.getBoundingClientRect()
    this.tokenTarget.classList.remove("no-move")
  }

  glide(el) {
    this.tokenTarget.hidden = false
    this.tokenTarget.classList.add("is-moving")
    this.move(el, true)
  }

  settle() {
    this.tokenTarget.classList.remove("is-moving")
    if (this.lastEl) this.move(this.lastEl, false)
  }

  async glideAndLand(el, generation) {
    this.glide(el)
    if (!await this.wait(GLIDE_MS, generation)) return false
    this.settle()
    this.markLanded(el)
    return true
  }

  markLanded(el) {
    el.classList.remove("landed")
    void el.offsetWidth
    el.classList.add("lit", "landed")
  }

  move(el, lift) {
    this.lastEl = el
    const stage = this.flowTarget.getBoundingClientRect()
    const box = el.getBoundingClientRect()
    const token = this.tokenTarget
    const x = box.left - stage.left + (box.width - token.offsetWidth) / 2
    const y = box.top - stage.top + (box.height - token.offsetHeight) / 2
    const scale = lift ? " scale(1.08)" : ""
    token.style.transform = `translate(${Math.round(x)}px, ${Math.round(y)}px)${scale}`
  }

  hideToken() {
    this.tokenTarget.hidden = true
  }

  stop() {
    this.generation += 1
    clearTimeout(this.timer)
    const resolve = this.resolveWait
    this.resolveWait = null
    if (resolve) resolve(false)
    if (this.hasPlayTarget) this.playTarget.setAttribute("aria-pressed", "false")
  }

  wait(ms, generation) {
    return new Promise((resolve) => {
      this.resolveWait = resolve
      this.timer = setTimeout(() => {
        this.resolveWait = null
        resolve(this.generation === generation)
      }, ms)
    })
  }
}
