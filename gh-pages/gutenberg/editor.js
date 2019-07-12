const { render, useState, Fragment } = wp.element;
const {
	BlockEditorProvider,
	BlockList,
	WritingFlow,
	ObserveTyping,
	BlockInspector,
} = wp.blockEditor;
const {
	Popover,
	SlotFillProvider,
	DropZoneProvider,
	Panel,
	PanelBody,
} = wp.components;
const { registerCoreBlocks } = wp.blockLibrary;

/**
 * Internal dependencies
 */
import './style.scss';

/* eslint-disable no-restricted-syntax */
import '@wordpress/components/build-style/style.css';
import '@wordpress/block-editor/build-style/style.css';
import '@wordpress/block-library/build-style/style.css';
import '@wordpress/block-library/build-style/editor.css';
import '@wordpress/block-library/build-style/theme.css';
import '@wordpress/format-library/build-style/style.css';

/* eslint-enable no-restricted-syntax */

function App() {
	const [ blocks, updateBlocks ] = useState( [] );

	return (
		<Fragment>
			<div className="playground__header">
				<h1 className="playground__logo">___title___</h1>
			</div>
			<div className="playground__body">
				<SlotFillProvider>
					<DropZoneProvider>
						<BlockEditorProvider
							value={ blocks }
							onInput={ updateBlocks }
							onChange={ updateBlocks }
						>
							<div className="editor-styles-wrapper">
								<WritingFlow>
									<ObserveTyping>
										<BlockList/>
									</ObserveTyping>
								</WritingFlow>
							</div>
							<Panel>
								<PanelBody className="edit-post-settings-sidebar__panel-block">
									<BlockInspector/>
								</PanelBody>
							</Panel>
							<Popover.Slot/>
						</BlockEditorProvider>
					</DropZoneProvider>
				</SlotFillProvider>
			</div>
		</Fragment>
	);
}

registerCoreBlocks();
render(
	<App/>,
	document.querySelector( '#app' ),
);
