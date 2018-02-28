Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-f193.google.com (mail-ot0-f193.google.com
 [74.125.82.193])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5496922352291
 for <linux-nvdimm@lists.01.org>; Wed, 28 Feb 2018 05:54:19 -0800 (PST)
Received: by mail-ot0-f193.google.com with SMTP id f11so2254328otj.12
 for <linux-nvdimm@lists.01.org>; Wed, 28 Feb 2018 06:00:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180228130410.GC3769@pd.tnic>
References: <20180222195811.27237-1-tony.luck@intel.com>
 <20180228130410.GC3769@pd.tnic>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Feb 2018 05:59:25 -0800
Message-ID: <CAPcyv4iHr9nUAS0SiFeqqDkU8NXZ_x=rkD3YS010Dy-nbHJXmA@mail.gmail.com>
Subject: Re: [PATCH 0/5] Teach EDAC about non-volatile DIMMs and add partial
 support to skx_edac
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
To: Borislav Petkov <bp@alien8.de>
Cc: Jean Delvare <jdelvare@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Aristeu Rozanski <aris@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Linux ACPI <linux-acpi@vger.kernel.org>, Tony Luck <tony.luck@intel.com>, Lv Zheng <lv.zheng@intel.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 28, 2018 at 5:04 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Feb 22, 2018 at 11:58:06AM -0800, Tony Luck wrote:
>> This series was posted as RFC and got some review back in December:
>>
>>    https://marc.info/?l=linux-edac&m=151257213825419&w=2
>>
>> It couldn't go upstream back then because I was waiting for some updates
>> to the ACPICA headers for NFIT support.  Those patches are complete now,
>> so here is the series again.
>>
>> The "partial support" part is that the changes here only do the detection of
>> the non-volatile DIMMs. Coming later will be another patch/series to teach
>> skx_edac how to decode system addresses to NVDIMM addresses. But this part
>> stands on its own and is a useful first step.
>>
>> Tony Luck (5):
>>   EDAC: Drop duplicated array of strings for memory type names
>>   edac: Add new memory type for non-volatile DIMMs
>>   acpi, nfit: Add function to look up nvdimm device and provide SMBIOS
>>     handle
>>   firmware: dmi: Add function to look up a handle and return DIMM size
>>   EDAC, skx_edac: Detect non-volatile DIMMs
>>
>>  drivers/acpi/nfit/core.c     | 27 ++++++++++++++++++
>>  drivers/edac/Kconfig         |  5 +++-
>>  drivers/edac/edac_mc.c       | 41 +++++++++++++-------------
>>  drivers/edac/edac_mc_sysfs.c | 26 ++---------------
>>  drivers/edac/skx_edac.c      | 68 ++++++++++++++++++++++++++++++++++++++++----
>>  drivers/firmware/dmi_scan.c  | 31 ++++++++++++++++++++
>>  include/acpi/nfit.h          | 26 +++++++++++++++++
>>  include/linux/dmi.h          |  2 ++
>>  include/linux/edac.h         |  3 ++
>>  9 files changed, 178 insertions(+), 51 deletions(-)
>>  create mode 100644 include/acpi/nfit.h
>
> Series looks ok to me.
>
> Dan, I could route patch 3 through the EDAC tree if you'd prefer.

Yes, please, and you can add:

Acked-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
