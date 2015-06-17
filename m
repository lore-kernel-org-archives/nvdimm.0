Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 17 Jun 2015 13:26:54 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v6 00/21] libnvdimm: non-volatile memory devices
Message-ID: <20150617112654.GA9246@lst.de>
References: <20150611183830.25175.51256.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150611183830.25175.51256.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Boaz Harrosh <boaz@plexistor.com>, rafael@kernel.org, neilb@suse.de, Dave Chinner <david@fromorbit.com>, Lv Zheng <lv.zheng@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, hch@lst.de, sfr@canb.auug.org.au, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, axboe@kernel.dk, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, linux-api@vger.kernel.org, akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Still not a big fan of the spec, but I guess this is a mosly reasonable
implementation now.

So for patches 1-16:

Acked-by: Christoph Hellwig <hch@lst.de>

The btt integration still needs a proper patch split and review, and
I still detest the mess with the test moduly by heart.

