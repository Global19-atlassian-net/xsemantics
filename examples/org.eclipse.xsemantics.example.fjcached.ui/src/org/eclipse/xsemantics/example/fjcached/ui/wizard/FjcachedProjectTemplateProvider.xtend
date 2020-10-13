/*
 * generated by Xtext 2.20.0
 */
package org.eclipse.xsemantics.example.fjcached.ui.wizard


import org.eclipse.core.runtime.Status
import org.eclipse.jdt.core.JavaCore
import org.eclipse.xtext.ui.XtextProjectHelper
import org.eclipse.xtext.ui.util.PluginProjectFactory
import org.eclipse.xtext.ui.wizard.template.IProjectGenerator
import org.eclipse.xtext.ui.wizard.template.IProjectTemplateProvider
import org.eclipse.xtext.ui.wizard.template.ProjectTemplate

import static org.eclipse.core.runtime.IStatus.*

/**
 * Create a list with all project templates to be shown in the template new project wizard.
 * 
 * Each template is able to generate one or more projects. Each project can be configured such that any number of files are included.
 */
class FjcachedProjectTemplateProvider implements IProjectTemplateProvider {
	override getProjectTemplates() {
		#[new HelloWorldProject]
	}
}

@ProjectTemplate(label="FJ (cached type system) Pair Example", icon="project_template.png", description="<p><b>FJ Pair Example</b></p>
<p>An example of FJ program: the Pair class and an FJ main expression.</p>")
final class HelloWorldProject {
	val advanced = check("Advanced:", false)
	val advancedGroup = group("Properties")
	val path = text("Package:", "fjcached", "The package path to place the files in", advancedGroup)

	override protected updateVariables() {
		path.enabled = advanced.value
		if (!advanced.value) {
			path.value = "fjcached"
		}
	}

	override protected validate() {
		if (path.value.matches('[a-z][a-z0-9_]*(/[a-z][a-z0-9_]*)*'))
			null
		else
			new Status(ERROR, "Wizard", "'" + path + "' is not a valid package name")
	}

	override generateProjects(IProjectGenerator generator) {
		generator.generate(new PluginProjectFactory => [
			projectName = projectInfo.projectName
			location = projectInfo.locationPath
			projectNatures += #[JavaCore.NATURE_ID, "org.eclipse.pde.PluginNature", XtextProjectHelper.NATURE_ID]
			builderIds += #[JavaCore.BUILDER_ID, XtextProjectHelper.BUILDER_ID]
			requiredBundles += #["org.eclipse.xsemantics.example.fjcached"]
			folders += "src"
			addFile('''src/«path»/Pair.fj''', '''
				/*
				 * This is an example FJ program
				 */
				
				class A extends Object { }
				class B extends Object { }
				
				class Pair extends Object {
				    Object fst;
				    Object snd;
				
				    Pair setfst(Object newfst) {
				        return new Pair(newfst, this.snd);
				    }
				
				    Pair setsnd(Object newscd) {
				        return new Pair(this.fst, newscd);
				    }
				}
				
				// the main expression
				new Pair(new A(), new B()).setfst(new A()).fst
			''')
		])
	}
}