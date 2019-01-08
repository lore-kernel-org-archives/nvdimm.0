Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 73C58211A3216
 for <linux-nvdimm@lists.01.org>; Mon,  7 Jan 2019 21:14:18 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id x23so2360948oix.3
 for <linux-nvdimm@lists.01.org>; Mon, 07 Jan 2019 21:14:18 -0800 (PST)
MIME-Version: 1.0
References: <20190108045853.5471-1-natechancellor@gmail.com>
In-Reply-To: <20190108045853.5471-1-natechancellor@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 7 Jan 2019 21:14:05 -0800
Message-ID: <CAPcyv4gA=qEm81k-f80oBBo9mmPcAg6szYQvtdOWFFWgd=9A4g@mail.gmail.com>
Subject: Re: [PATCH] nfit: Hide unused functions behind CONFIG_X86
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
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: kbuild test robot <lkp@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 7, 2019 at 8:59 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On arm64 little endian allyesconfig:
>
> drivers/acpi/nfit/intel.c:149:12: warning: unused function 'intel_security_unlock' [-Wunused-function]
> static int intel_security_unlock(struct nvdimm *nvdimm,
>            ^
> drivers/acpi/nfit/intel.c:230:12: warning: unused function 'intel_security_erase' [-Wunused-function]
> static int intel_security_erase(struct nvdimm *nvdimm,
>            ^
> drivers/acpi/nfit/intel.c:279:12: warning: unused function 'intel_security_query_overwrite' [-Wunused-function]
> static int intel_security_query_overwrite(struct nvdimm *nvdimm)
>            ^
> drivers/acpi/nfit/intel.c:316:12: warning: unused function 'intel_security_overwrite' [-Wunused-function]
> static int intel_security_overwrite(struct nvdimm *nvdimm,
>            ^
> 4 warnings generated.
>
> These functions are only used in __intel_security_ops when CONFIG_X86 is
> set so only define these functions under that same condition.

Thanks for the report, not sure how the kbuild robot missed this. I'd
prefer marking the functions __maybe_unused rather than expanding the
ifdef guards.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
