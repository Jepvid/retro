
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retro/features/create/create_custom_sequences/create_custom_sequences_viewmodel.dart';
import 'package:retro/features/create/create_finish/create_finish_viewmodel.dart';
import 'package:retro/l10n/app_localizations.dart';
import 'package:retro/ui/components/custom_scaffold.dart';

class CreateCustomSequencesScreen extends StatefulWidget {
  const CreateCustomSequencesScreen({super.key});

  @override
  _CreateCustomSequencesScreenState createState() => _CreateCustomSequencesScreenState();
}

class _CreateCustomSequencesScreenState extends State<CreateCustomSequencesScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CreateCustomSequencesViewModel>(context);
    final finishViewModel = Provider.of<CreateFinishViewModel>(context);
    final i18n = AppLocalizations.of(context)!;

    String nameWithoutExtension(String path, String basePath) {
      return path.split('$basePath/').last.split('.').first;
    }

    Future<void> onStagePressed() async {
      if (finishViewModel.keepFolderOpenAfterStaging) {
        if (finishViewModel.entries.isEmpty) {
          // Staged queue is empty.
          viewModel.stagedHashes.clear();
        }
        await viewModel.rescanFolder();
        if (viewModel.sequenceMetaPairs.isNotEmpty) {
          finishViewModel.onAddCustomSequenceEntry(viewModel.sequenceMetaPairs, 'custom/music');
          await viewModel.recordStagedHashes();
          viewModel.clearSequenceMetaPairs();
        }
      } else {
        finishViewModel.onAddCustomSequenceEntry(viewModel.sequenceMetaPairs, 'custom/music');
        viewModel.reset();
        Navigator.of(context).popUntil(ModalRoute.withName('/create_selection'));
      }
    }

    final canPressStage = finishViewModel.keepFolderOpenAfterStaging
        ? viewModel.selectedFolderPath != null
        : viewModel.sequenceMetaPairs.isNotEmpty;

    return CustomScaffold(
        title: i18n.createCustomSequences_addCustomSequences,
        subtitle: i18n.createCustomSequences_addCustomSequencesDescription,
        onBackButtonPressed: () {
          viewModel.reset();
          Navigator.of(context).pop();
        },
        content: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Row(children: [
                Expanded(
                    child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: viewModel.selectedFolderPath ?? i18n.createCustomSequences_SequencesFolderPath,
                  ),
                ),),
                const SizedBox(width: 12),
                ElevatedButton(
                    onPressed: viewModel.onSelectFolder,
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 50),),
                    child: Text(i18n.createCustomSequences_selectButton),)
              ],),
              if (viewModel.isProcessing || viewModel.sequenceMetaPairs.isNotEmpty)
                Expanded(
                    child: viewModel.isProcessing
                        ? const Center(child: CircularProgressIndicator())
                        : Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ListView.builder(
                                itemCount: viewModel.sequenceMetaPairs.length,
                                prototypeItem: const SizedBox(width: 0, height: 20),
                                itemBuilder: (context, index) {
                                  return Text(nameWithoutExtension(viewModel.sequenceMetaPairs[index].item1.path, viewModel.selectedFolderPath!));
                                },),),),
              if (!viewModel.isProcessing && viewModel.sequenceMetaPairs.isEmpty)
                const Spacer(),
                Row(children: [
                  Switch(
                    activeColor: Colors.blue,
                    value: finishViewModel.keepFolderOpenAfterStaging,
                    onChanged: (value) {
                      finishViewModel.onToggleKeepFolderOpenAfterStaging(value);
                    },
                  ),
                  Text(i18n.createCustomSequences_keepFolderOpenToggle),
                ],),
                ElevatedButton(
                  onPressed: canPressStage ? onStagePressed : null,
                  style: ElevatedButton.styleFrom(minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.5, 50,),
                  ),
                  child: Text(finishViewModel.keepFolderOpenAfterStaging
                      ? i18n.createCustomSequences_scanAndStageFiles
                      : i18n.createCustomSequences_stageFiles),
                )
            ],),
        ),),
      );
  }
}