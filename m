Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 39B8721A07A92
 for <linux-nvdimm@lists.01.org>; Thu,  8 Nov 2018 08:32:07 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id u130-v6so17423336oie.7
 for <linux-nvdimm@lists.01.org>; Thu, 08 Nov 2018 08:32:07 -0800 (PST)
MIME-Version: 1.0
References: <D9FFE20C522965449E182ACE73889AEBF4FB0B37@IRSMSX101.ger.corp.intel.com>
In-Reply-To: <D9FFE20C522965449E182ACE73889AEBF4FB0B37@IRSMSX101.ger.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 8 Nov 2018 08:31:54 -0800
Message-ID: <CAPcyv4gaARF3xEX0uWKDHbutKhWNcwm7wV_wj+pfFoArAj01Jg@mail.gmail.com>
Subject: Re: nfit_test.ko.xz needs unknown symbol ....
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
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 8, 2018 at 6:45 AM Dorau, Lukasz <lukasz.dorau@intel.com> wrote:
>
> Hi,
>
> I am building and installing the linux kernel from the 'libnvdimm-for-next' branch at git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git with the 'nfit_test' kernel module.
>
> I have set in the .config file:
>
> CONFIG_X86_PMEM_LEGACY=m
> CONFIG_ZONE_DEVICE=y
> CONFIG_LIBNVDIMM=m
> CONFIG_BLK_DEV_PMEM=m
> CONFIG_ND_BLK=m
> CONFIG_BTT=y
> CONFIG_NVDIMM_PFN=y
> CONFIG_NVDIMM_DAX=y
> CONFIG_DEV_DAX_PMEM=m
>
> I ran:
>
> $ make
> $ make M=tools/testing/nvdimm
> $ sudo make M=tools/testing/nvdimm modules_install
> $ sudo make modules_install
>
> and I got:
>
> [...]
> DEPMOD  4.19.0-rc4-nfit_test
> depmod: WARNING: /lib/modules/4.19.0-rc4-nfit_test/extra/test/nfit_test.ko.xz needs unknown symbol libnvdimm_test
> depmod: WARNING: /lib/modules/4.19.0-rc4-nfit_test/extra/test/nfit_test.ko.xz needs unknown symbol acpi_nfit_test
> depmod: WARNING: /lib/modules/4.19.0-rc4-nfit_test/extra/test/nfit_test.ko.xz needs unknown symbol pmem_test
> depmod: WARNING: /lib/modules/4.19.0-rc4-nfit_test/extra/test/nfit_test.ko.xz needs unknown symbol device_dax_test
>
> Does anyone know what could be wrong here?

Do you get the error if you run the same script again? For external
modules to find symbols the symbol map needs to be installed, but the
first time you run the process nothing has been installed. So, it's
possible to see this error on the first run on a new kernel version,
but it's benign and should disappear for subsequent builds.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
