package org.lisaac.ldt.wizards;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IFolder;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IProjectDescription;
import org.eclipse.core.resources.IWorkspaceRoot;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.QualifiedName;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.operation.IRunnableWithProgress;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.wizard.Wizard;
import org.eclipse.ui.INewWizard;
import org.eclipse.ui.IWorkbench;
import org.eclipse.ui.dialogs.WizardNewProjectCreationPage;
import org.lisaac.ldt.LisaacMessages;
import org.lisaac.ldt.builder.LisaacNature;
import org.lisaac.ldt.editors.LisaacResourceDecorator;
import org.lisaac.ldt.model.LisaacModel;


public class NewProjectWizard extends Wizard implements INewWizard {

	NewProjectWizardPage mainPage;

	public NewProjectWizard() {
		super();
		setNeedsProgressMonitor(true);
	}

	// called with the 'finish' button
	public boolean performFinish() {
		final String name;
		final IPath path;
		IRunnableWithProgress op = null;
		try {
			name = mainPage.getProjectName();
			path = mainPage.getLocationPath();
			//lisaacPath = mainPage.getLisaacPath();
			op = new IRunnableWithProgress() {
				public void run(IProgressMonitor monitor) throws InvocationTargetException {
					try {						
						doFinish(name, path, monitor);
					} catch (CoreException e) {
						throw new InvocationTargetException(e);
					} finally {
						monitor.done();
					}
				}
			};
		} catch (NullPointerException e1) {
			e1.printStackTrace();
		}

		try {
			getContainer().run(false, false, op);
		} catch (InterruptedException e) {
			return false;
		} catch (InvocationTargetException e) {
			Throwable realException = e.getTargetException();
			MessageDialog.openError(getShell(), "Error !", realException.getMessage()); //$NON-NLS-1$
			return false;
		}
		return true;
	}

	private void doFinish(String projectName, IPath nomRep, IProgressMonitor monitor)
	throws CoreException
	{
		monitor.beginTask("Project Creation " + projectName, 4); //$NON-NLS-1$

		// get project root
		IWorkspaceRoot root = ResourcesPlugin.getWorkspace().getRoot();

		try {
			IProject project = root.getProject(projectName);
			if (project.exists() && !project.isOpen()) {
				project.open(monitor);
			} else {
				project.create(monitor);
				project.open(monitor);
			}
			try {

				// set lisaac builder
				LisaacNature nature = new LisaacNature();
				nature.setProject(project);
				nature.configure();

				// set lisaac nature
				IProjectDescription description = project.getDescription();
				description.setNatureIds(new String[]{LisaacNature.NATURE_ID});
				project.setDescription(description, monitor);

			} catch (CoreException e) {
				// Something went wrong
			}
			monitor.worked(1);

			//
			new LisaacModel(project);
			//

			monitor.worked(1);

			// create make file for project
			IFile lipFile = project.getFile("make.lip"); //$NON-NLS-1$
			if (! lipFile.exists()) {
				lipFile.create(new ByteArrayInputStream(getLipStream(project)), false, monitor);
			}

			// create default folder & files in project
			IFolder src = project.getFolder("src"); //$NON-NLS-1$
			if (! src.exists()) {
				src.create(false, true, monitor);
				src.setPersistentProperty(
						new QualifiedName("", LisaacResourceDecorator.SOURCE_FOLDER_PROPERTY),
				"true");
			}

			monitor.worked(1);
			IFile mainPrototype = src.getFile(projectName.toLowerCase()+".li"); //$NON-NLS-1$
			if (! mainPrototype.exists()) {
				mainPrototype.create(new ByteArrayInputStream(getMainPrototypeStream(projectName)), false, monitor);
			}
			IFolder bin = project.getFolder("bin"); //$NON-NLS-1$
			if (! bin.exists()) {
				bin.create(false,true,monitor);
			}
			monitor.worked(1);
			IFolder lib = project.getFolder("lib"); //$NON-NLS-1$
			if (! lib.exists()) {
				// create link to lib
				/*IPath location = new Path(lisaacPath+"/lib");// FIXME path delimiter
				lib.createLink(location, IResource.NONE, monitor);*/
				lib.create(false,true,monitor);
				lib.setPersistentProperty(
						new QualifiedName("", LisaacResourceDecorator.LIB_PROPERTY),
				"true");
			}
		} catch (IOException e) {
			MessageDialog.openError(getShell(), "Project creation Error !", e.getMessage());	 //$NON-NLS-1$
		} catch (CoreException e) {
			MessageDialog.openError(getShell(), "Project settings Error !", e.getMessage()); //$NON-NLS-1$
		}
		monitor.done();
	}


	public byte[] getMainPrototypeStream(String projectName) throws IOException {
		String contents = "\nSection Header\n\n"; //$NON-NLS-1$
		contents +=	"  + name    := "+projectName.toUpperCase()+";\n"; //$NON-NLS-1$ //$NON-NLS-2$
		contents +=	"  - comment := \"Main Prototype\";\n";  //$NON-NLS-1$
		contents +=	"\nSection Inherit\n\n";  //$NON-NLS-1$
		contents += "  - parent_object:OBJECT := OBJECT;\n"; //$NON-NLS-1$
		contents +=	"\nSection Public\n\n";  //$NON-NLS-1$
		contents += "  - main <- \n"; //$NON-NLS-1$
		contents += "  // Main entry point.\n"; //$NON-NLS-1$
		contents += "  (\n\n"; //$NON-NLS-1$
		contents += "    \n"; //$NON-NLS-1$
		contents += "  );\n"; //$NON-NLS-1$
		return contents.getBytes();
	}

	public byte[] getLipStream(IProject project) throws IOException {
		String contents = "//\n// `"+project.getName()+"`  LIsaac Project file\n//"; //$NON-NLS-1$ //$NON-NLS-2$
		contents += "\nSection Inherit\n\n"; //$NON-NLS-1$
		contents += "  + parent:STRING;\n"; //$NON-NLS-1$
		contents +=	"\nSection Private\n\n";  //$NON-NLS-1$
		contents += "  + project_root:STRING := \""+project.getLocationURI().getPath()+"/\";\n\n"; //$NON-NLS-1$ //$NON-NLS-2$
		contents += "  - project_src_path <- \n"; //$NON-NLS-1$
		contents += "  // Define the project path for source code.\n"; //$NON-NLS-1$
		contents += "  (\n"; //$NON-NLS-1$
		contents += "    path (project_root + \"src/\");\n"; //$NON-NLS-1$
		contents += "  );\n\n"; //$NON-NLS-1$
		contents += "  - front_end <- \n"; //$NON-NLS-1$
		contents += "  // Executed by compiler, before compilation step.\n"; //$NON-NLS-1$
		contents += "  (\n"; //$NON-NLS-1$
		contents += "    project_src_path;\n"; //$NON-NLS-1$
		contents += "    general_front_end;\n"; //$NON-NLS-1$
		contents += "  );\n"; //$NON-NLS-1$
		contents +=	"\nSection Public\n\n"; //$NON-NLS-1$
		contents += "  - debug_mode <- \n"; //$NON-NLS-1$
		contents += "  // Run in Debug Mode.\n"; //$NON-NLS-1$
		contents += "  (\n"; //$NON-NLS-1$
		contents += "    debug 15; // default level [1-20]\n"; //$NON-NLS-1$
		contents += "  );\n\n"; //$NON-NLS-1$
		contents += "  - clean <- \n"; //$NON-NLS-1$
		contents += "  // Clean project.\n"; //$NON-NLS-1$
		contents += "  (\n"; //$NON-NLS-1$
		contents += "  );\n"; //$NON-NLS-1$
		return contents.getBytes();
	}

	public void init(IWorkbench workbench, IStructuredSelection selection) {
		setWindowTitle(LisaacMessages.getString("NewProjectWizard_46"));
		setNeedsProgressMonitor(true);
		mainPage = new NewProjectWizardPage(LisaacMessages.getString("NewProjectWizard_47"));
	}

	public void addPages() {
		super.addPages(); 
		addPage(mainPage);      
	}
}

class NewProjectWizardPage extends WizardNewProjectCreationPage {

	NewProjectWizardPage(String pageName) {
		super(pageName);
		setTitle(pageName);
		setDescription(LisaacMessages.getString("NewProjectWizard_48")); 
	}
}
/*
class LicenseWizardPage extends WizardPage {

	private Text licenseText;

	LicenseWizardPage(String pageName) {
		super(pageName);
		setTitle(pageName);
		setDescription("Specify the project license"); 
	}

	public String getLicense() {
		return licenseText.getText();
	}

	public void createControl(Composite parent) {
		Composite composite = new Composite(parent, SWT.NONE);
		composite.setLayout(new GridLayout());
        composite.setLayoutData(new GridData(GridData.FILL_BOTH));

		licenseText = new Text(composite, SWT.MULTI);
		licenseText.setLayoutData(new GridData(GridData.FILL_BOTH));

		setControl(composite);
	}
}*/
