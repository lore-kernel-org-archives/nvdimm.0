Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F5AA21BADAB2
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 19:04:56 -0800 (PST)
Date: Tue, 15 Jan 2019 11:04:39 +0800
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: Re: [PATCH] acpi/nfit: remove duplicate set nd_set in
 acpi_nfit_init_interleave_set()
Message-ID: <20190115030439.GA4040@richard>
References: <20190114021929.3658-1-richardw.yang@linux.intel.com>
 <CAPcyv4h7DeZmoRMxNpC2nGCWHJEw_QOy2J6nev037Ywtd-NTKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4h7DeZmoRMxNpC2nGCWHJEw_QOy2J6nev037Ywtd-NTKQ@mail.gmail.com>
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
Cc: Ross Zwisler <zwisler@kernel.org>, Wei Yang <richardw.yang@linux.intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jan 13, 2019 at 08:41:11PM -0800, Dan Williams wrote:
>On Sun, Jan 13, 2019 at 6:19 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
>>
>> We allocate nd_set in acpi_nfit_init_interleave_set() and assignn it to
>> ndr_desc, while the assignment is done twice in this function.
>>
>> This patch removes the second assignment. No functional change.
>
>I think it makes more sense to remove the first assignment. Don't let
>an uninitialized nd_set escape that routine. Either ->nd_set is left
>NULL or it points to an initialized instance instead of potentially a
>zeroed one.

Agree, I should be more careful.

-- 
Wei Yang
Help you, Help me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
