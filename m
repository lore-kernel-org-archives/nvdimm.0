Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B212C2095609E
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 07:18:15 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id c12so5821096oic.7
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 07:24:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180315081118.vivohgn6vrt74pyc@linux-x5ow.site>
References: <20180314182508.10351-1-jthumshirn@suse.de>
 <20180315072257.GA14576@infradead.org>
 <20180315081118.vivohgn6vrt74pyc@linux-x5ow.site>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Mar 2018 07:24:37 -0700
Message-ID: <CAPcyv4jj5HBJOBFNcWMGRg5DufLKJj-=BCVVORWpVno9p270Zg@mail.gmail.com>
Subject: Re: [PATCH 0/3] Introduce module_nd_driver
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
Cc: Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux NV-DIMM Mailing List <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 15, 2018 at 1:11 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On Thu, Mar 15, 2018 at 12:22:57AM -0700, Christoph Hellwig wrote:
>> What is the point?  It saves a hand fulk of lines, while making
>> the code both harder to read and harder to extend.
>
> In the end it's just style alignment with most of the other "busses"
> in the kernel, like pci, of, acpi, platform and so on...
>
> But yes I admit it's not a huge win. For the harder to read part, I
> doubt it. A quick:
> git grep -E module_.*._driver drivers/ | wc -l
> has 3896 hit's, so it's not that uncommon ;-)
>
> But anyways, it's just code churn I came up with while being
> frustrated hunting down a bug in this subsystem.
>

Works for me. Removing more lines than you add is always welcome.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
