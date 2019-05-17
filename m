Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from eu-smtp-delivery-151.mimecast.com
 (eu-smtp-delivery-151.mimecast.com [207.82.80.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4576721253310
 for <linux-nvdimm@lists.01.org>; Fri, 17 May 2019 09:14:07 -0700 (PDT)
From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead
Date: Fri, 17 May 2019 16:14:03 +0000
Message-ID: <ac76e29576b14fcb9a18e5a9e6ab8394@AcuMS.aculab.com>
References: <155805321833.867447.3864104616303535270.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190517084739.GB20550@quack2.suse.cz>
 <2d8b1ba7890940bf8a512d4eef0d99b3@AcuMS.aculab.com>
 <201905170845.1B4E2A03@keescook>
In-Reply-To: <201905170845.1B4E2A03@keescook>
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
To: 'Kees Cook' <keescook@chromium.org>
Cc: Jeff Smits <jeff.smits@intel.com>, Matthew Wilcox <willy@infradead.org>, 'Jan Kara' <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

From: Kees Cook
> Sent: 17 May 2019 16:54
...
> > I've changed some of our code to use __get_user() to avoid
> > these stupid overheads.
> 
> __get_user() skips even access_ok() checking too, so that doesn't seem
> like a good idea. Did you run access_ok() checks separately? (This
> generally isn't recommended.)

Of course, I'm not THAT stupid :-)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
