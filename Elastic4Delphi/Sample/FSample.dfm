object FForm: TFForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Integra'#231#227'o DocFiscAll'
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
    Caption = 'Emiss'#227'o NFCE - Requisi'#231#227'o'
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
    Lines.Strings = (
      '{'
      '    "RP": "99999991",'
      '    "_id": "270220241432",'
      '    "codigoDaReserva": "123",'
      '    "dataCompetencia": "2024-02-27",'
      '    "dataEmissao": "2024-02-27",'
      '    "destinatario": {'
      '            "endereco": {'
      '                    "bairro": "Cidade de Deus",'
      '                    "codMunicipioIBGE": "1302603",'
      '                    "logradouro": "Rua Jutic'#225'",'
      '                    "nomeCidade": "Manaus",'
      '                    "uf": "AM"'
      '            },'
      '            "nome": "Theo Xavier Jr.",'
      '            "numDocumento": "72345042656",'
      '            "retemServico": false'
      '    },'
      '    "itens": ['
      '            {'
      '                    "codigoCEST": "0302100",'
      '                    "codigoEAN": "78906938",'
      '                    "codigoEANTributavel": "78906938",'
      '                    "codigoNCM": "22030000",'
      '                    "codigoProduto": "003",'
      '                    "descricaoProduto": "CERVEJA HEINEKEN '
      '355ML",'
      '                    "indicadorTotal": "itCompoeValorNota",'
      '                    "outrosValores": 333,'
      '                    "quantidade": 10,'
      '                    "quantidadeTributavel": 10,'
      '                    "unidadeMedida": "UN",'
      '                    "unidadeMedidaTributavel": "UN",'
      '                    "valorUnitario": 333,'
      '                    "valorUnitarioTributavel": 333'
      '            }'
      '    ],'
      '    "pagamentos": ['
      '            {'
      '                    "bandeiraCartao": "boVisa",'
      '                    "cnpjCredenciadora": "01027058000191",'
      '                    "codigoAutorizacao": "3955155",'
      '                    "forma": "fpCartaoCredito",'
      '                    "nsuTransacao": "4222297",'
      '                    "tipoIntegracao": "tipPOS",'
      '                    "tipoIntegracaoPagamento": "tipPOS",'
      '                    "valor": 3663'
      '            }'
      '    ],'
      '    "serie": "107",'
      '    "valorTotalNF": 3663,'
      '    "valorTroco": 0'
      '}')
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
