Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 25C7A210BFF53
 for <linux-nvdimm@lists.01.org>; Tue,  3 Jul 2018 12:21:30 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id i12-v6so6075973oik.2
 for <linux-nvdimm@lists.01.org>; Tue, 03 Jul 2018 12:21:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.1807040358010.32123@namei.org>
References: <153057423804.38125.15912575101400055843.stgit@djiang5-desk3.ch.intel.com>
 <153057476931.38125.15448927598576316449.stgit@djiang5-desk3.ch.intel.com>
 <AT5PR8401MB1169BD7B3DE8CDA8BA5AE658AB420@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4ipAULUgtV6rvx7hQBLtjr7VSE25KvBiHxHRe7TT0HvKA@mail.gmail.com>
 <alpine.LRH.2.21.1807040358010.32123@namei.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 3 Jul 2018 12:21:29 -0700
Message-ID: <CAPcyv4gCUd-Gi_G-sLAaZDAyhxzBjH9+iBp1oh3UFfSWdf3RDg@mail.gmail.com>
Subject: Re: [PATCH 04/11] nfit/libnvdimm: add unlock of nvdimm support for
 Intel DIMMs
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
To: James Morris <jmorris@namei.org>
Cc: "Schofield, Alison" <alison.schofield@intel.com>, "keescook@chromium.org" <keescook@chromium.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "dhowells@redhat.com" <dhowells@redhat.com>, "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 3, 2018 at 11:00 AM, James Morris <jmorris@namei.org> wrote:
> On Mon, 2 Jul 2018, Dan Williams wrote:
>
>> If an attacker can run arbitrary code in the kernel they can get the
>> key from the ring directly, or turn on ACPI debug. A platform could
>> arrange for the DIMMs to be unlocked pre-OS to minimize passphrase
>> exposure,
>
> So, either from within UEFI secure boot, or via the bootloader?

Correct. The ATA security model that these commands are based on
assumes a laptop/desktop style interactive input of the hardware
passphrase. However, for servers that do unattended boots and
potentially retrieve the key from a hosted data center key service,
the proposal is to use the kernel's keyctl service to communicate the
passphrase to the kernel.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
