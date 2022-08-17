#!/bin/sh
set -e
set -x
if [ -z "$INPUT_SOURCE_FOLDER" ]
then
  echo "Source folder must be defined"
  return -1
fi
if [ $INPUT_DESTINATION_HEAD_BRANCH == "main" ] || [ $INPUT_DESTINATION_HEAD_BRANCH == "master"]
then
  echo "Destination head branch cannot be 'main' nor 'master'"
  return -1
fi
if [ -z "$INPUT_PULL_REQUEST_REVIEWERS" ]
then
  PULL_REQUEST_REVIEWERS=$INPUT_PULL_REQUEST_REVIEWERS
else
  PULL_REQUEST_REVIEWERS='-r '$INPUT_PULL_REQUEST_REVIEWERS
fi
# CLONE_DIR=$(mktemp -d)
CLONE_SEC=$(mktemp -d)
echo "Setting git variables"
export GITHUB_TOKEN=$API_TOKEN_GITHUB
git config --global user.email "$INPUT_USER_EMAIL"
git config --global user.name "$INPUT_USER_NAME"
# echo "Cloning destination git repository"

#TESTE CLONAR REPO Destination e criar branch vazia
git clone "https://$API_TOKEN_GITHUB@github.com/$INPUT_DESTINATION_REPO.git" "$CLONE_SEC"
cd "$CLONE_SEC"
cp -R $INPUT_SOURCE_FOLDER "$CLONE_SEC/$INPUT_DESTINATION_FOLDER"
git checkout --orphan "BranchVazia" main
git rm -rf .
git clean -fdx
#FIM TESTE CLONAR REPO Destination

#Copiar principal para o novo repository
git add .
git commit --message "Agora vai"
git push -u origin "BranchVazia"
#Fim Copiar principal para o novo repository

# #aaaaaaaaaaaaaaaaaaaaaaaaaaa

# git clone "https://$API_TOKEN_GITHUB@github.com/$INPUT_BASE_REPO.git" "$CLONE_DIR"

# echo "Copying contents to git repo"-r $INPUT_USER_NAME
# # cp -R $INPUT_SOURCE_FOLDER "$CLONE_DIR/$INPUT_DESTINATION_FOLDER"
# cd "$CLONE_DIR"
# git checkout -b "branchPrincipal"

# # Criar branch vazia no repositorio destino
# # Copiar os arquivos do repositorio base para a nova branch
# # criar pr da branchvazia (agr n mais) para a main do repositorio destino

# # teste criar ranch vazia
# git checkout --orphan "BranchVazia"
# git rm -rf .
# git clean -fdx
# # FIM teste criar ranch vazia


# #teste
# git push -u origin "branchPrincipal"
# #fim teste



# #TESTE PR
# gh pr create -t meAjude \
#               -b meAjude \
#               -B branchPrincipal \
#               -H meAjude \
#                 $PULL_REQUEST_REVIEWERS
# # gh pr create -B branchPrincipal -t "algo" -b "algo"           
# #FIM TESTE PR

# # # Teste merge
# # git remote add main-repository https://github.com/Fit-jhameson-farias/main-repository.git
# # git fetch main-repository --tags
# # git merge --allow-unrelated-histories main-repository/main
# # git remote remove main-repository
# # #fim teste merge

# # echo "Adding git commit"
# # git add .
# # if git status | grep -q "Changes to be committed"
# # then
# #   git commit --message "Update from https://github.com/$GITHUB_REPOSITORY/commit/$GITHUB_SHA"
# #   echo "Pushing git commit"
# #   git push -u origin HEAD:$INPUT_DESTINATION_HEAD_BRANCH
# #   echo "Creating a pull request"
# #   gh pr create -t $INPUT_DESTINATION_HEAD_BRANCH \
# #                -b $INPUT_DESTINATION_HEAD_BRANCH \
# #                -B $INPUT_DESTINATION_BASE_BRANCH \
# #                -H $INPUT_DESTINATION_HEAD_BRANCH \
# #                   $PULL_REQUEST_REVIEWERS
# # else
# #   echo "No changes detected"
# # fi