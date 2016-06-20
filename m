Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x22a.google.com (mail-lf0-x22a.google.com
 [IPv6:2a00:1450:4010:c07::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A09501A1E25
 for <linux-nvdimm@lists.01.org>; Mon, 20 Jun 2016 00:34:09 -0700 (PDT)
Received: by mail-lf0-x22a.google.com with SMTP id q132so31885458lfe.3
 for <linux-nvdimm@lists.01.org>; Mon, 20 Jun 2016 00:33:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hiOwx5LM+80Hz7jWnidMrKVjY9V5B3zS7y_g7C1KLoYQ@mail.gmail.com>
References: <1466340570-2471502-1-git-send-email-yigal@plexistor.com>
 <CAPcyv4hiOwx5LM+80Hz7jWnidMrKVjY9V5B3zS7y_g7C1KLoYQ@mail.gmail.com>
From: Yigal Korman <yigal@plexistor.com>
Date: Mon, 20 Jun 2016 10:33:19 +0300
Message-ID: <CACTTzNakp+1-HM47imr5mpyOCM8_QcppwdA+gJRTBvjTA0+WkA@mail.gmail.com>
Subject: Re: [RFC] x86/mm: only allow memmap=XX!YY over existing RAM
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
Cc: linux-efi@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Matt Fleming <matt@codeblueprint.co.uk>
List-ID: <linux-nvdimm@lists.01.org>

Hi,
I've sent this to the wrong maintainer by mistake (sorry about that)
so I going to re-post it again in a moment.
FYI

Thanks,
Yigal

On Sun, Jun 19, 2016 at 7:40 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Sun, Jun 19, 2016 at 5:49 AM, Yigal Korman <yigal@plexistor.com> wrote:
>> Before this patch, passing a range that is beyond the physical memory
>> range will succeed, the user will see a /dev/pmem0 and will be able to
>> access it. Reads will always return 0 and writes will be silently
>> ignored.
>>
>> I've gotten more than one bug report about mkfs.{xfs,ext4} or nvml
>> failing that were eventually tracked down to be wrong values passed to
>> memmap.
>>
>> This patch prevents the above issue by instead of adding a new memory
>> range, only update a RAM memory range with the PRAM type. This way,
>> passing the wrong memmap will either not give you a pmem at all or give
>> you a smaller one that actually has RAM behind it.
>>
>> And if someone still needs to fake a pmem that doesn't have RAM behind
>> it, they can simply do memmap=XX@YY,XX!YY.
>
> Thanks!  I've debugged a report like this as well.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
