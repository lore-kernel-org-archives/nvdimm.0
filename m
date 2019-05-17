Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from eu-smtp-delivery-151.mimecast.com
 (eu-smtp-delivery-151.mimecast.com [146.101.78.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4395F212733FE
 for <linux-nvdimm@lists.01.org>; Fri, 17 May 2019 02:06:31 -0700 (PDT)
From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead
Date: Fri, 17 May 2019 09:06:26 +0000
Message-ID: <2d8b1ba7890940bf8a512d4eef0d99b3@AcuMS.aculab.com>
References: <155805321833.867447.3864104616303535270.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190517084739.GB20550@quack2.suse.cz>
In-Reply-To: <20190517084739.GB20550@quack2.suse.cz>
Content-Language: en-US
MIME-Version: 1.0
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
To: 'Jan Kara' <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>
Cc: Jeff Smits <jeff.smits@intel.com>, Matthew Wilcox <willy@infradead.org>, Kees Cook <keescook@chromium.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

From: Jan Kara
> Sent: 17 May 2019 09:48
...
> So this last paragraph is not obvious to me as check_copy_size() does a lot
> of various checks in CONFIG_HARDENED_USERCOPY case. I agree that some of
> those checks don't make sense for PMEM pages but I'd rather handle that by
> refining check_copy_size() and check_object_size() functions to detect and
> appropriately handle pmem pages rather that generally skip all the checks
> in pmem_copy_from/to_iter(). And yes, every check in such hot path is going
> to cost performance but that's what user asked for with
> CONFIG_HARDENED_USERCOPY... Kees?

Except that all the distros enable it by default.
So you get the performance cost whether you (as a user) want it or not.

I've changed some of our code to use __get_user() to avoid
these stupid overheads.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
