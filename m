Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD8D620337359
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 07:46:06 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id d189-v6so17352292oib.6
 for <linux-nvdimm@lists.01.org>; Thu, 05 Jul 2018 07:46:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180705082931.echvdqipgvwhghf2@linux-x5ow.site>
References: <153077334130.40830.2714147692560185329.stgit@dwillia2-desk3.amr.corp.intel.com>
 <153077341292.40830.11333232703318633087.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180705082931.echvdqipgvwhghf2@linux-x5ow.site>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 5 Jul 2018 07:46:05 -0700
Message-ID: <CAPcyv4h1L6ZMCqWXhWD_ZJ=sH7SVzuUGMG2Ln=6Cy6sR4S=VUw@mail.gmail.com>
Subject: Re: [PATCH 13/13] libnvdimm, namespace: Publish page structure init
 state / control
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 5, 2018 at 1:29 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On Wed, Jul 04, 2018 at 11:50:13PM -0700, Dan Williams wrote:
>> +static ssize_t memmap_state_store(struct device *dev,
>> +             struct device_attribute *attr, const char *buf, size_t len)
>> +{
>> +     int i;
>> +     struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
>> +     struct memmap_async_state *async = &nd_pfn->async;
>> +
>> +     if (strcmp(buf, "sync") == 0)
>> +             /* pass */;
>> +     else if (strcmp(buf, "sync\n") == 0)
>> +             /* pass */;
>> +     else
>> +             return -EINVAL;
>
> Hmm what about:
>
>         if (strncmp(buf, "sync", 4))
>            return -EINVAL;
>
> This collapses 6 lines into 4.

...but that also allows 'echo "syncAndThenSomeGarbage" >
/sys/.../memmap_state' to succeed.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
