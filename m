Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 84D462218E92B
 for <linux-nvdimm@lists.01.org>; Fri, 22 Dec 2017 21:10:07 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id
 vBN5EDdY091742
 for <linux-nvdimm@lists.01.org>; Sat, 23 Dec 2017 00:14:57 -0500
Received: from e06smtp14.uk.ibm.com (e06smtp14.uk.ibm.com [195.75.94.110])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2f19yntadg-1
 (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Sat, 23 Dec 2017 00:14:57 -0500
Received: from localhost
 by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <khandual@linux.vnet.ibm.com>;
 Sat, 23 Dec 2017 05:14:54 -0000
Subject: Re: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
References: <20171214021019.13579-1-ross.zwisler@linux.intel.com>
 <2d6420f7-0a95-adfe-7390-a2aea4385ab2@linux.vnet.ibm.com>
 <5d7df981-69c2-e371-f48d-13c418fff134@intel.com>
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Date: Sat, 23 Dec 2017 10:44:34 +0530
MIME-Version: 1.0
In-Reply-To: <5d7df981-69c2-e371-f48d-13c418fff134@intel.com>
Message-Id: <3bffaacf-e927-fb06-4dd0-3821f6f82dad@linux.vnet.ibm.com>
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
To: Dave Hansen <dave.hansen@intel.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: "Box, David E" <david.e.box@intel.com>, linux-mm@kvack.org, "Zheng, Lv  <lv.zheng@intel.com>, linux-nvdimm@lists.01.org, Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, Robert, Lukasz, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, devel@acpica.org, Kogut,, "Marcin  <marcin.koss@intel.com>, Brice Goglin" <brice.goglin@gmail.com>, "Nachimuthu, Murugasamy  <murugasamy.nachimuthu@intel.com>, Rafael J. Wysocki" <rjw@rjwysocki.net>, Koziej,, "Joonas  <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen" <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 12/22/2017 10:43 PM, Dave Hansen wrote:
> On 12/21/2017 07:09 PM, Anshuman Khandual wrote:
>> I had presented a proposal for NUMA redesign in the Plumbers Conference this
>> year where various memory devices with different kind of memory attributes
>> can be represented in the kernel and be used explicitly from the user space.
>> Here is the link to the proposal if you feel interested. The proposal is
>> very intrusive and also I dont have a RFC for it yet for discussion here.
> I think that's the best reason to "re-use NUMA" for this: it's _not_
> intrusive.
> 
> Also, from an x86 perspective, these HMAT systems *will* be out there.
> Old versions of Linux *will* see different types of memory as separate
> NUMA nodes.  So, if we are going to do something different, it's going
> to be interesting to un-teach those systems about using the NUMA APIs
> for this.  That ship has sailed.

I understand the need to fetch these details from ACPI/DT for
applications to target these distinct memory only NUMA nodes.
This can be done by parsing from platform specific values from
/proc/acpi/ or /proc/device-tree/ interfaces. This can be a
short term solution before NUMA redesign can be figured out.
But adding generic devices like "hmat" in the /sys/devices/
path which will be locked for good, seems problematic.
   

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
