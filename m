Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8A24B211BED6C
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 10:57:42 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id u16so541022otk.8
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 10:57:42 -0800 (PST)
MIME-Version: 1.0
References: <PU1P153MB01691690696D8F83FC1872C7BF900@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB01691690696D8F83FC1872C7BF900@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 30 Jan 2019 10:57:30 -0800
Message-ID: <CAPcyv4g_dmR77ofqCR3Zy_V2inD_0WTgLLJOqTcB6=SSZZjp8w@mail.gmail.com>
Subject: Re: [PATCH] nfit: Collect shutdown status for NVDIMM_FAMILY_HYPERV
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
To: Dexuan Cui <decui@microsoft.com>
Cc: Josh Poulson <jopoulso@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Haiyang Zhang <haiyangz@microsoft.com>, "driverdev-devel@linuxdriverproject.org" <driverdev-devel@linuxdriverproject.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Kelley <mikelley@microsoft.com>, Sasha Levin <Alexander.Levin@microsoft.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, Stephen Hemminger <sthemmin@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jan 30, 2019 at 10:49 AM Dexuan Cui <decui@microsoft.com> wrote:
>
>
> See http://www.uefi.org/RFIC_LIST ("Virtual NVDIMM 0x1901"):
> "Get Unsafe Shutdown Count (Function Index 2)".
>
> Let's expose the info to the userspace (e.g. ntctl) via sysfs.
>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  drivers/acpi/nfit/core.c   | 51 ++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/nfit/hyperv.h | 26 +++++++++++++++++++
>  2 files changed, 77 insertions(+)
>  create mode 100644 drivers/acpi/nfit/hyperv.h

Looks ok to me, but if we grow any more of these "shutdown count"
retrievals I'll want to take a look at being able to call
acpi_nfit_ctl() earlier in the init process so that this data
marshaling can be unified.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
