Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <20180108112646.GA7204@lst.de>
References: <20171229075406.1936-1-hch@lst.de> <20180108112646.GA7204@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 8 Jan 2018 11:44:02 -0800
Message-ID: <CAPcyv4hHipDHP5LZCgym5szqiUSCxG9wQUbRO_qe8T+USaZi9Q@mail.gmail.com>
Subject: Re: revamp vmem_altmap / dev_pagemap handling V3
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-nvdimm@lists.01.org, X86 ML <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 8, 2018 at 3:26 AM, Christoph Hellwig <hch@lst.de> wrote:
> Any chance to get this fully reviewed and picked up before the
> end of the merge window?

I'm fine carrying these through the nvdimm tree, but I'd need an ack
from the mm folks for all the code touches related to arch_add_memory.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
