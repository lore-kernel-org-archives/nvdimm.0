Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D40E203369D5
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 13:34:02 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id w126-v6so19360808oie.7
 for <linux-nvdimm@lists.01.org>; Thu, 05 Jul 2018 13:34:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180705132455.2a40de08dbe3a9bb384fb870@linux-foundation.org>
References: <153077334130.40830.2714147692560185329.stgit@dwillia2-desk3.amr.corp.intel.com>
 <153077341292.40830.11333232703318633087.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180705082931.echvdqipgvwhghf2@linux-x5ow.site>
 <CAPcyv4h1L6ZMCqWXhWD_ZJ=sH7SVzuUGMG2Ln=6Cy6sR4S=VUw@mail.gmail.com>
 <20180705144941.drfiwhqcnqqorqu3@linux-x5ow.site>
 <20180705132455.2a40de08dbe3a9bb384fb870@linux-foundation.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 5 Jul 2018 13:34:01 -0700
Message-ID: <CAPcyv4h973nANXOUFe9rE7pn0tKxy=Csh=XYsyA6V_bPF0eRAw@mail.gmail.com>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 5, 2018 at 1:24 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 5 Jul 2018 16:49:41 +0200 Johannes Thumshirn <jthumshirn@suse.de> wrote:
>
>> On Thu, Jul 05, 2018 at 07:46:05AM -0700, Dan Williams wrote:
>> > ...but that also allows 'echo "syncAndThenSomeGarbage" >
>> > /sys/.../memmap_state' to succeed.
>>
>> Yep it does :-(.
>>
>> Damn
>
> sysfs_streq()

Nice... /me stares down a long list of needed cleanups in the
libnvdimm sysfs implementation with that gem.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
