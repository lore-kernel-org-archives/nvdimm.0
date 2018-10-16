Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from esa17.fujitsucc.c3s2.iphmx.com (esa17.fujitsucc.c3s2.iphmx.com
 [216.71.158.34])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2567221142FFE
 for <linux-nvdimm@lists.01.org>; Mon, 15 Oct 2018 21:09:52 -0700 (PDT)
From: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
Subject: RE: [ndctl PATCH v13 2/5] ndctl, monitor: add main ndctl monitor
 configuration file
Date: Tue, 16 Oct 2018 04:09:44 +0000
Message-ID: <OS2PR01MB0836B4F845FDD0AFC3997966F7FE0@OS2PR01MB0836.jpnprd01.prod.outlook.com>
References: <20180713233350.7148-1-qi.fuli@jp.fujitsu.com>
 <20180713233350.7148-3-qi.fuli@jp.fujitsu.com>
 <CAPcyv4h4VaLXV2Mj8VcZmvREyn=YtgC0AtBV1SEdDJ3YDKY5=Q@mail.gmail.com>
In-Reply-To: <CAPcyv4h4VaLXV2Mj8VcZmvREyn=YtgC0AtBV1SEdDJ3YDKY5=Q@mail.gmail.com>
Content-Language: en-US
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: 'Dan Williams' <dan.j.williams@intel.com>
Cc: "tokunaga.keiich@fujitsu.com" <tokunaga.keiich@fujitsu.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> 
> Hi,
> 
> I have a future cleanup request. I've just come across, ciniparser [1]. It would
> be great if we could drop the open coded implementation and just use that library.
> We use ccan modules for other portions of ndctl.
> 
> [1]: https://ccodearchive.net/info/ciniparser.html

Hi Dan,

It sounds good.
I will study on it a bit and then make a cleanup patch.

Thank you very much.
 Qi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
