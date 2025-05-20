import { Application } from "@hotwired/stimulus"

export function eagerLoadControllersFrom(controllers, application) {
  controllers.forEach(controller => application.register(controller.name, controller.module.default))
}