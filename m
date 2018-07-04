Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3BEAF209831E9
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 08:27:25 -0700 (PDT)
Subject: Re: [PATCH 3/3] kvm: add a function to check if page is from NVDIMM
 pmem.
References: <cover.1530716899.git.yi.z.zhang@linux.intel.com>
 <359fdf0103b61014bf811d88d4ce36bc793d18f2.1530716899.git.yi.z.zhang@linux.intel.com>
 <CAPcyv4is0T1SjsaC4Z80ND9Q_032_Tsa0hQwkO84T0FCRj5MkA@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fe420914-212f-a18e-b6ec-f2b7a451c0d2@redhat.com>
Date: Wed, 4 Jul 2018 17:27:17 +0200
MIME-Version: 1.0
In-Reply-To: <CAPcyv4is0T1SjsaC4Z80ND9Q_032_Tsa0hQwkO84T0FCRj5MkA@mail.gmail.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>, Zhang Yi <yi.z.zhang@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, KVM list <kvm@vger.kernel.org>, "Zhang," Yu C" <yu.c.zhang@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>," rkrcmar@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Christoph Hellwig <hch@lst.de>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 04/07/2018 16:50, Dan Williams wrote:
>> +       return is_zone_device_page(page) &&
>> +               ((page->pgmap->type == MEMORY_DEVICE_FS_DAX) ||
>> +                (page->pgmap->type == MEMORY_DEVICE_DEV_DAX));
> Jerome, might there be any use case to pass MEMORY_DEVICE_PUBLIC
> memory to a guest vm?
> 

An even better reason to place this in mm.h. :)  There should be an
function to tell you if a reserved page has accessed/dirty bits etc.,
that's all that KVM needs to know.

Paolo
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
