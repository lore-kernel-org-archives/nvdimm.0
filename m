Return-Path: <owner-linux-mm@kvack.org>
Date: Sat, 15 Aug 2015 15:33:55 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 1/7] x86, mm: ZONE_DEVICE for "device memory"
Message-ID: <20150815133355.GA24382@lst.de>
References: <20150813031253.36913.29580.stgit@otcpl-skl-sds-2.jf.intel.com> <20150813035005.36913.77364.stgit@otcpl-skl-sds-2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150813035005.36913.77364.stgit@otcpl-skl-sds-2.jf.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, boaz@plexistor.com, riel@redhat.com, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, david@fromorbit.com, mingo@kernel.org, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, mgorman@suse.de, "H. Peter Anvin" <hpa@zytor.com>, ross.zwisler@linux.intel.com, torvalds@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 12, 2015 at 11:50:05PM -0400, Dan Williams wrote:
> arch_add_memory() is reorganized a bit in preparation for a new
> arch_add_dev_memory() api, for now there is no functional change to the
> memory hotplug code.

Instead of the new arch_add_dev_memory call I'd just add a bool device
argument to arch_add_memory and zone_for_memory (and later the altmap
pointer aswell).

arch_add_memory is a candidate to be factored into common code,
except for s390 everything could be done with two small arch callouts.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
