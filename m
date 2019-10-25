Return-Path: <SRS0=R6EX=YS=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803E6CA9EBC
	for <linux-nvdimm@archiver.kernel.org>; Fri, 25 Oct 2019 15:46:55 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3A5F321D7B
	for <linux-nvdimm@archiver.kernel.org>; Fri, 25 Oct 2019 15:46:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A5F321D7B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nk-bbw.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id E0AE9100EEBB5;
	Fri, 25 Oct 2019 08:48:07 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=133.18.9.210; helo=o4022-121.kagoya.net; envelope-from=zzzsmz3@kagoya.net; receiver=<UNKNOWN> 
Received: from o4022-121.kagoya.net (o4022-121.kagoya.net [133.18.9.210])
	by ml01.01.org (Postfix) with ESMTP id 68846100EEBB1
	for <linux-nvdimm@lists.01.org>; Fri, 25 Oct 2019 08:48:05 -0700 (PDT)
Received: by o4022-121.kagoya.net (Postfix, from userid 499206)
	id DA4FD34164B; Sat, 26 Oct 2019 00:07:40 +0900 (JST)
Date: Fri, 25 Oct 2019 15:07:40 +0000
To: linux-nvdimm@lists.01.org
From: DHL DELIVERY SERVICE <dhldeliveryservice5@nk-bbw.net>
Subject: =?utf-8?Q?=44=48=4c=20=50=41=43=4b=41=47=45=20=44=45=4c=49=56=45=52=59?=
Message-ID: <8e69ea5c472762c1ed27e1cb60849b62@nk-bbw.net>
X-Priority: 1
MIME-Version: 1.0
Message-ID-Hash: 4CCW3OYKFUKG34OW4OHQ67USKN2CQQOK
X-Message-ID-Hash: 4CCW3OYKFUKG34OW4OHQ67USKN2CQQOK
X-MailFrom: zzzsmz3@kagoya.net
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/4CCW3OYKFUKG34OW4OHQ67USKN2CQQOK/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: multipart/mixed; boundary="===============6622073373288053467=="

--===============6622073373288053467==
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<SPAN style=3D'FONT-SIZE: 116px; FONT-FAMILY: "times new roman","new york=
",times,serif; BORDER-RIGHT-WIDTH: 1px; BORDER-TOP-COLOR: rgb(48,121,237)=
; WHITE-SPACE: normal; BORDER-BOTTOM-WIDTH: 1px; WORD-SPACING: 0px; TEXT-=
TRANSFORM: none; FONT-WEIGHT: bold; COLOR: rgb(188,9,19); FONT-STYLE: nor=
mal; BORDER-BOTTOM-COLOR: rgb(48,121,237); TEXT-ALIGN: center; PADDING-LE=
FT: 8px; MIN-HEIGHT: 49px; ORPHANS: 2; WIDOWS: 2; BORDER-RIGHT-COLOR: rgb=
(48,121,237); LETTER-SPACING: normal; LINE-HEIGHT: 49px; PADDING-RIGHT: 8=
px; BORDER-TOP-WIDTH: 1px; BACKGROUND-COLOR: rgb(255,182,4); TEXT-INDENT:=
 0px'><SPAN style=3D"FONT-SIZE: large; FONT-FAMILY: Georgia" size=3D"4"><=
B><I>=3DD H L=3D</I></B></SPAN></SPAN><SPAN style=3D'FONT-SIZE: 14px; FON=
T-FAMILY: Helvetica,"Microsoft Yahei",verdana; WHITE-SPACE: normal; WORD-=
SPACING: 0px; TEXT-TRANSFORM: none; FLOAT: none; FONT-WEIGHT: 400; COLOR:=
 rgb(0,0,0); FONT-STYLE: normal; ORPHANS: 2; WIDOWS: 2; DISPLAY: inline !=
important; LETTER-SPACING: normal; TEXT-INDENT: 0px'>
<P style=3D'FONT-SIZE: 16px; FONT-FAMILY: "times new roman","new york",ti=
mes,serif; WHITE-SPACE: normal; WORD-SPACING: 0px; TEXT-TRANSFORM: none; =
FONT-WEIGHT: 400; COLOR: rgb(0,0,0); FONT-STYLE: normal; MARGIN: 0px; ORP=
HANS: 2; WIDOWS: 2; LETTER-SPACING: normal; LINE-HEIGHT: 27px; TEXT-INDEN=
T: 0px'><BR><SPAN style=3D"FONT-SIZE: small; FONT-FAMILY: Arial,Helvetica=
,sans-serif; COLOR: rgb(34,34,34)"><SPAN style=3D"FONT-FAMILY: verdana,sa=
ns-serif; COLOR: rgb(0,0,0)" face=3D"verdana, sans-serif">Dear Linux-nvdi=
mm,</SPAN><BR><BR>Your business partner sent you a package sent to you vi=
a our courier service=E3=80=82<BR><BR>Before we start the final delivery =
to your address, we need to confirm that you are the actual recipient.=E3=
=80=82<BR><BR></SPAN><SPAN style=3D"FONT-SIZE: medium; FONT-FAMILY: verda=
na,sans-serif" size=3D"3" face=3D"verdana, sans-serif">Please click below=
 to confirm your shipping address with us to ensure smooth and fast deliv=
ery=E3=80=82</SPAN></P><SPAN style=3D"FONT-SIZE: medium; FONT-FAMILY: ver=
da
 na,sans-serif" size=3D"3" face=3D"verdana, sans-serif"></SPAN>
<P style=3D'FONT-SIZE: 16px; FONT-FAMILY: "times new roman","new york",ti=
mes,serif; WHITE-SPACE: normal; WORD-SPACING: 0px; TEXT-TRANSFORM: none; =
FONT-WEIGHT: 400; COLOR: rgb(0,0,0); FONT-STYLE: normal; MARGIN: 0px; ORP=
HANS: 2; WIDOWS: 2; LETTER-SPACING: normal; LINE-HEIGHT: 27px; TEXT-INDEN=
T: 0px'><BR style=3D"FONT-SIZE: small; FONT-FAMILY: Arial,Helvetica,sans-=
serif; COLOR: rgb(34,34,34)"><SPAN style=3D'FONT-SIZE: 16px; FONT-FAMILY:=
 "times new roman","new york",times,serif; BORDER-RIGHT-WIDTH: 1px; BORDE=
R-TOP-COLOR: rgb(48,121,237); WHITE-SPACE: normal; BORDER-BOTTOM-WIDTH: 1=
px; WORD-SPACING: 0px; TEXT-TRANSFORM: none; FONT-WEIGHT: bold; COLOR: rg=
b(188,9,19); FONT-STYLE: normal; BORDER-BOTTOM-COLOR: rgb(48,121,237); TE=
XT-ALIGN: center; PADDING-LEFT: 8px; MIN-HEIGHT: 49px; ORPHANS: 2; WIDOWS=
: 2; BORDER-RIGHT-COLOR: rgb(48,121,237); LETTER-SPACING: normal; LINE-HE=
IGHT: 49px; PADDING-RIGHT: 8px; BORDER-TOP-WIDTH: 1px; BACKGROUND-COLOR: =
rgb(255,182,4); TEXT-INDENT: 0px'><SPAN style=3D"
 FONT-SIZE: large; FONT-FAMILY: Georgia" size=3D"4"><U><A href=3D"https:/=
/canzzz.burrow.io/newrr1/?lists.01.org
=3DLinux-nvdimm&raven=3DLinux-nvdimm@lists.01.org
&ggggggggghtytytyjjitytjhtyryyggfyyhg">Tracking Your DHL Package</A></U><=
EM>=C2=A0=C2=A0=C2=A0=C2=A0</EM></SPAN></SPAN><SPAN style=3D'FONT-SIZE: 1=
4px; FONT-FAMILY: Helvetica,"Microsoft Yahei",verdana; WHITE-SPACE: norma=
l; WORD-SPACING: 0px; TEXT-TRANSFORM: none; FLOAT: none; FONT-WEIGHT: 400=
; COLOR: rgb(0,0,0); FONT-STYLE: normal; ORPHANS: 2; WIDOWS: 2; DISPLAY: =
inline !important; LETTER-SPACING: normal; TEXT-INDENT: 0px'><SPAN>=C2=A0=
</SPAN></SPAN></P>
<P style=3D'FONT-SIZE: 16px; FONT-FAMILY: "times new roman","new york",ti=
mes,serif; WHITE-SPACE: normal; WORD-SPACING: 0px; TEXT-TRANSFORM: none; =
FONT-WEIGHT: 400; COLOR: rgb(0,0,0); FONT-STYLE: normal; MARGIN: 0px; ORP=
HANS: 2; WIDOWS: 2; LETTER-SPACING: normal; LINE-HEIGHT: 27px; TEXT-INDEN=
T: 0px'><SPAN style=3D'FONT-SIZE: 14px; FONT-FAMILY: Helvetica,"Microsoft=
 Yahei",verdana; WHITE-SPACE: normal; WORD-SPACING: 0px; TEXT-TRANSFORM: =
none; FLOAT: none; FONT-WEIGHT: 400; COLOR: rgb(0,0,0); FONT-STYLE: norma=
l; ORPHANS: 2; WIDOWS: 2; DISPLAY: inline !important; LETTER-SPACING: nor=
mal; TEXT-INDENT: 0px'><SPAN></SPAN></SPAN><BR style=3D"FONT-SIZE: small;=
 FONT-FAMILY: Arial,Helvetica,sans-serif; COLOR: rgb(34,34,34)"><SPAN sty=
le=3D"FONT-SIZE: small; FONT-FAMILY: verdana,sans-serif" face=3D"verdana,=
 sans-serif">if you can't verify your address can result in delayed deliv=
ery or loss of important file=E3=80=82</SPAN><BR style=3D"FONT-SIZE: smal=
l; FONT-FAMILY: Arial,Helvetica,sans-serif; COLOR: rgb(34,3
 4,34)"><BR style=3D"FONT-SIZE: small; FONT-FAMILY: Arial,Helvetica,sans-=
serif; COLOR: rgb(34,34,34)"></P>
<DIV style=3D"FONT-SIZE: small; FONT-FAMILY: Arial,Helvetica,sans-serif; =
WHITE-SPACE: normal; WORD-SPACING: 0px; TEXT-TRANSFORM: none; FONT-WEIGHT=
: 400; COLOR: rgb(34,34,34); FONT-STYLE: normal; ORPHANS: 2; WIDOWS: 2; L=
ETTER-SPACING: normal; TEXT-INDENT: 0px" dir=3Dltr>heartfelt,</DIV>
<DIV style=3D"FONT-SIZE: small; FONT-FAMILY: Arial,Helvetica,sans-serif; =
WHITE-SPACE: normal; WORD-SPACING: 0px; TEXT-TRANSFORM: none; FONT-WEIGHT=
: 400; COLOR: rgb(34,34,34); FONT-STYLE: normal; ORPHANS: 2; WIDOWS: 2; L=
ETTER-SPACING: normal; TEXT-INDENT: 0px" dir=3Dltr>DHL Worldwide Delivery=
</DIV>
--===============6622073373288053467==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

--===============6622073373288053467==--
