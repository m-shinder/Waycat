subdir('languages')

sources = [files(
    'main.vala',
    'WaycatApp.vala',
    'Block.vala',
    'DragWrapper.vala',
    'Language.vala',
    'ui-left-sidemenu.vala',
    'ui-workbench.vala',
    'ui-right-stack.vala',
    'ui-middle-top-buttons.vala',
), resources, languages]

dependencies = [
    dependency ('gobject-2.0'),
    dependency ('gmodule-2.0'),
    dependency ('glib-2.0'),
    dependency ('gtk4', version: '>= 4.0.0'),
    dependency ('gee-0.8'),
    dependency ('gtksourceview-5'),
    dependency ('python-3.8-embed'),
    meson.get_compiler ('c').find_library ('m', required: false),
]
vala_args = [
	'--gresources', resource_files,
#	'--vapidir', files('languages/Python381/tokens.vapi'),
]
executable (
    meson.project_name(),
    sources: sources,
    dependencies: dependencies,
    vala_args: vala_args,
    install: true,
)
