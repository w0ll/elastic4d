object FForm: TFForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'elastic4d'
  ClientHeight = 423
  ClientWidth = 1001
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object FLabelRequisicao: TLabel
    Left = 8
    Top = 8
    Width = 128
    Height = 13
    Caption = 'elastic4d'
  end
  object FLabelResponse: TLabel
    Left = 344
    Top = 8
    Width = 45
    Height = 13
    Caption = 'Resposta'
  end
  object FLabelResponseElastic: TLabel
    Left = 680
    Top = 8
    Width = 110
    Height = 13
    Caption = 'Resposta Elasticsearch'
  end
  object FMemoRequest: TMemo
    Left = 8
    Top = 27
    Width = 313
    Height = 357
    Lines.Strings = ()
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object FButtonEnviarNFCe: TButton
    Left = 8
    Top = 390
    Width = 75
    Height = 25
    Caption = 'Enviar'
    TabOrder = 1
    OnClick = FButtonEnviarNFCeClick
  end
  object FMemoResponse: TMemo
    Left = 344
    Top = 27
    Width = 313
    Height = 357
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object FMemoResponseElastic: TMemo
    Left = 680
    Top = 27
    Width = 313
    Height = 357
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object FButtonListarNFCe: TButton
    Left = 89
    Top = 390
    Width = 75
    Height = 25
    Caption = 'Listar'
    TabOrder = 4
    OnClick = FButtonListarNFCeClick
  end
  object FButtonCEP: TButton
    Left = 185
    Top = 390
    Width = 41
    Height = 25
    Caption = 'CEP'
    TabOrder = 5
    OnClick = FButtonCEPClick
  end
  object FEditCEP: TEdit
    Left = 224
    Top = 392
    Width = 97
    Height = 21
    TabOrder = 6
    Text = '22250040'
  end
end
