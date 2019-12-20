# md2spec
Convert markdown to ruby spec

# Usage
- Put the script in an executable directory
  - ex) `/usr/local/bin/md2spec`
  - `ln -s /Users/volpe/repo/github.com/volpe28v/md2spec/bin/md2spec /usr/local/bin/md2spec`
- Describe test cases in a file with markdown
- Run the following command
```
$ md2spec sample.md
```

# Example
- Input
```
- d: ほげ設定
    - d: ほげ一覧を表示する
        - i: ほげ一覧が表示されること
            - ほげセレクトボックスを表示
            - ほげを選択
            - ふが画面を表示
        - c: ほげが取得できない場合
            - i:エラー画面を表示すること
    - d: ほげの選択状態を保持する
        - i: 最後に更新したほげの選択状態が保持されること
            - ほげを選択
            - 更新ボタン
            - 別のほげを選択
            - 更新ボタン
            - ほげ設定の「詳細設定」を選択
            - 最後に更新したほげが表示されること
```

- Output
```
describe 'ほげ設定' do
  describe 'ほげ一覧を表示する' do
    xit 'ほげ一覧が表示されること' do
      # ほげセレクトボックスを表示
      # ほげを選択
      # ふが画面を表示
    end
    context 'ほげが取得できない場合' do
      xit 'エラー画面を表示すること' do
      end
    end
  end
  describe 'ほげの選択状態を保持する' do
    xit '最後に更新したほげの選択状態が保持されること' do
      # ほげを選択
      # 更新ボタン
      # 別のほげを選択
      # 更新ボタン
      # ほげ設定の「詳細設定」を選択
      # 最後に更新したほげが表示されること
    end
  end
end
```
