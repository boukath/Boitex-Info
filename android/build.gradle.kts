// Project-wide Gradle configuration for a Flutter app using Kotlin DSL.

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Put all build outputs under <repo>/build to avoid polluting android/
rootProject.layout.buildDirectory.value(
    rootProject.layout.buildDirectory.dir("../../build").get()
)

subprojects {
    project.layout.buildDirectory.value(
        rootProject.layout.buildDirectory.dir(project.name).get()
    )
}

// Optional: lock dependencies for reproducible builds (matches Flutter template behavior)
subprojects {
    project.evaluationDependsOn(":app")
    dependencyLocking {
        ignoredDependencies.add("io.flutter:*")
        lockFile = file("${rootProject.projectDir}/project-${project.name}.lockfile")
        if (!project.hasProperty("local-engine-repo")) {
            lockAllConfigurations()
        }
    }
}

// Standard clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
