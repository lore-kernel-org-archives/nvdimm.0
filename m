Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from namei.org (namei.org [65.99.196.166])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3311E210ED0EA
 for <linux-nvdimm@lists.01.org>; Tue,  3 Jul 2018 11:00:22 -0700 (PDT)
Date: Wed, 4 Jul 2018 04:00:09 +1000 (AEST)
From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 04/11] nfit/libnvdimm: add unlock of nvdimm support for
 Intel DIMMs
In-Reply-To: <CAPcyv4ipAULUgtV6rvx7hQBLtjr7VSE25KvBiHxHRe7TT0HvKA@mail.gmail.com>
Message-ID: <alpine.LRH.2.21.1807040358010.32123@namei.org>
References: <153057423804.38125.15912575101400055843.stgit@djiang5-desk3.ch.intel.com>
 <153057476931.38125.15448927598576316449.stgit@djiang5-desk3.ch.intel.com>
 <AT5PR8401MB1169BD7B3DE8CDA8BA5AE658AB420@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4ipAULUgtV6rvx7hQBLtjr7VSE25KvBiHxHRe7TT0HvKA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Schofield, Alison" <alison.schofield@intel.com>, "keescook@chromium.org" <keescook@chromium.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "dhowells@redhat.com" <dhowells@redhat.com>, "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2 Jul 2018, Dan Williams wrote:

> If an attacker can run arbitrary code in the kernel they can get the
> key from the ring directly, or turn on ACPI debug. A platform could
> arrange for the DIMMs to be unlocked pre-OS to minimize passphrase
> exposure, 

So, either from within UEFI secure boot, or via the bootloader?

-- 
James Morris
<jmorris@namei.org>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
