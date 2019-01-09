Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1CAB821B02822
 for <linux-nvdimm@lists.01.org>; Tue,  8 Jan 2019 22:22:24 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id y1so5407058oie.12
 for <linux-nvdimm@lists.01.org>; Tue, 08 Jan 2019 22:22:24 -0800 (PST)
MIME-Version: 1.0
References: <20190108045853.5471-1-natechancellor@gmail.com>
 <20190109050036.17322-1-natechancellor@gmail.com>
In-Reply-To: <20190109050036.17322-1-natechancellor@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 8 Jan 2019 22:22:12 -0800
Message-ID: <CAPcyv4iBUx66WNpZ5zRvT+Rn+ydPvwB40jbtdpoKLAVFDYh95w@mail.gmail.com>
Subject: Re: [PATCH v2] nfit: Mark some functions as __maybe_unused
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 8, 2019 at 9:03 PM Nathan Chancellor
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
> Mark these functions as __maybe_unused because they are only used when
> CONFIG_X86 is set.
>
> Fixes: 4c6926a23b76 ("acpi/nfit, libnvdimm: Add unlock of nvdimm support for Intel DIMMs")
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Looks good, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
