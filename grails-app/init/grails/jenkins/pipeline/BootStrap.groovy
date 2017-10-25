package grails.jenkins.pipeline

import grails.util.Holders

class BootStrap {

    def init = { servletContext ->

        println "commit id = " +  Holders.config.commitid
    }
    def destroy = {
    }
}
