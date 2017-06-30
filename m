Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x231.google.com (mail-yb0-x231.google.com
 [IPv6:2607:f8b0:4002:c09::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 37DA521C943C4
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 18:26:42 -0700 (PDT)
Received: by mail-yb0-x231.google.com with SMTP id 84so34061566ybe.0
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 18:28:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <595589CF.5010605@hpe.com>
References: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149875884190.10031.6179599135820559644.stgit@dwillia2-desk3.amr.corp.intel.com>
 <595552F5.5040008@hpe.com>
 <CAPcyv4jr0U-a521+wAL7RDca_AoUrtvO6yeY6d0UQpY7d=CHuQ@mail.gmail.com>
 <59556E37.80808@hpe.com>
 <CAPcyv4g6ijkWncZAbP-Bmbf+J7a2hR-JFLSX-ji6v-+oG0PDJQ@mail.gmail.com>
 <d073b4a1-ff90-b44a-adf2-ad44c0d70c69@hpe.com>
 <CAPcyv4huf0ENTz=LEVC6xC7xKRPc-GAZJsZMTSYpy+UoaduTMg@mail.gmail.com>
 <595580A6.9000004@hpe.com>
 <CAPcyv4gtTYEUELPtr9mi5QkGL+cm=jcFR-Oe07OCuNM9izh6jA@mail.gmail.com>
 <d545a1ea-0199-7462-58c5-067cdc22cacc@hpe.com>
 <CAPcyv4gnkpWXJ7jOJ7r0kWLKoLfuqJzdHTjANBUPztyTWUrOjA@mail.gmail.com>
 <595589CF.5010605@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Jun 2017 18:28:14 -0700
Message-ID: <CAPcyv4iTaXc92ggQcBnqJ=P0jsMF9HhnV4nAsr1Qos4pjrRDLA@mail.gmail.com>
Subject: Re: [PATCH v4 12/16] libnvdimm,
 nfit: enable support for volatile ranges
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 29, 2017 at 4:14 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 06/29/2017 06:58 PM, Dan Williams wrote:
>> On Thu, Jun 29, 2017 at 3:49 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>>>> The parent region of the namespace will have a 'volatile' type:
>>>>
>>>> # cat /sys/bus/nd/devices/region0/devtype
>>>> nd_volatile
>>>
>>>
>>> If all I know is the /dev/pmem device name, how do I find that?
>>>
>>
>>     cat $(readlink -f /sys/block/pmem0/device)/../devtype
>>
>> ...this is where 'ndctl list' will get the information.
>>
>
> Thanks.
>
> I think we need a section 4 pmem manpage like exists for
> mem, sd, fd, md, etc., where we can put stuff like this, as well
> as providing some overview information that will point people to
> other resources.  I'll give that some thought unless there is one
> already that I'm not finding.
>

A "pmem" man page sounds like a great idea, I wasn't aware we even had
an sd man page.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
