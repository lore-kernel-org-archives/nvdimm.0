Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8F51521A070B8
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jun 2019 17:27:19 -0700 (PDT)
Date: Wed, 26 Jun 2019 08:26:54 +0800
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: Re: [PATCH] libnvdimm, namespace: check nsblk->uuid immediately
 after its allocation
Message-ID: <20190626002654.GA29091@richard>
References: <20190116065144.3499-1-richardw.yang@linux.intel.com>
 <20190604031041.GA27794@richard>
 <CAPcyv4j4xGmM5BGqQu9Y2RFDa55Y0AMOn9Z0jXra334igBtwgA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4j4xGmM5BGqQu9Y2RFDa55Y0AMOn9Z0jXra334igBtwgA@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <zwisler@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 25, 2019 at 03:06:42PM -0700, Dan Williams wrote:
>On Mon, Jun 3, 2019 at 8:11 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
>>
>> Hi, Dan
>>
>> Do you have some time on this?
>>
>> On Wed, Jan 16, 2019 at 02:51:44PM +0800, Wei Yang wrote:
>> >When creating nd_namespace_blk, its uuid is copied from nd_label->uuid.
>> >In case the memory allocation fails, it goes to the error branch.
>> >
>> >This check is better to be done immediately after memory allocation,
>> >while current implementation does this after assigning claim_class.
>> >
>> >This patch moves the check immediately after uuid allocation.
>
>This looks ok, but the patch has no significant impact. I'm not
>particularly motivated to carry it forward.

Got it. Thanks

-- 
Wei Yang
Help you, Help me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
