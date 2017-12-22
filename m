Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1FA102219BC9B
 for <linux-nvdimm@lists.01.org>; Fri, 22 Dec 2017 06:33:11 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id
 vBMEYgBb049579
 for <linux-nvdimm@lists.01.org>; Fri, 22 Dec 2017 09:38:01 -0500
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2f12muched-1
 (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Fri, 22 Dec 2017 09:38:00 -0500
Received: from localhost
 by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <khandual@linux.vnet.ibm.com>;
 Fri, 22 Dec 2017 14:37:58 -0000
Subject: Re: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
References: <20171214021019.13579-1-ross.zwisler@linux.intel.com>
 <2d6420f7-0a95-adfe-7390-a2aea4385ab2@linux.vnet.ibm.com>
 <34EF90DF7C7F0647A403B771519912C7F5382CF3@irsmsx111.ger.corp.intel.com>
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Date: Fri, 22 Dec 2017 20:07:31 +0530
MIME-Version: 1.0
In-Reply-To: <34EF90DF7C7F0647A403B771519912C7F5382CF3@irsmsx111.ger.corp.intel.com>
Message-Id: <c3930c61-0fe4-960e-2b55-dbd281dfb148@linux.vnet.ibm.com>
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
To: "Kogut, Jaroslaw" <Jaroslaw.Kogut@intel.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Box, David E" <david.e.box@intel.com>, Hansen,, "Lv  <lv.zheng@intel.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Wysocki,, Lukasz, "Robert  <robert.moore@intel.com>, linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Odzioba,, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, "devel@acpica.org" <devel@acpica.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "Koss, Marcin  <marcin.koss@intel.com>, Brice Goglin <brice.goglin@gmail.com>, Nachimuthu, Murugasamy" <murugasamy.nachimuthu@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Koziej,, "Joonas  <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen" <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 12/22/2017 04:01 PM, Kogut, Jaroslaw wrote:
>> ... first thinking about redesigning the NUMA for
>> heterogeneous memory may not be a good idea. Will look into this further.
> I agree with comment that first a direction should be defined how to handle heterogeneous memory system.
> 
>> https://linuxplumbersconf.org/2017/ocw//system/presentations/4656/original/
>> Hierarchical_NUMA_Design_Plumbers_2017.pdf
> I miss in the presentation a user perspective of the new approach, e.g.
> - How does application developer see/understand the heterogeneous memory system?

>From user perspective

- Each memory node (with or without CPU) is a NUMA node with attributes
- User should detect these NUMA nodes from sysfs (not part of proposal)
- User allocates/operates/destroys VMA with new sys calls (_mattr based)

> - How does app developer use the heterogeneous memory system?

- Through existing and new system calls

> - What are modification in API/sys interfaces?

- The presentation has possible addition of new system calls with 'u64
  _mattr' representation for memory attributes which can be used while
  requesting different kinds of memory from the kernel

> 
> In other hand, if we assume that separate memory NUMA node has different memory capabilities/attributes from stand point of particular CPU, it is easy to explain for user how to describe/handle heterogeneous memory. 
> 
> Of course, current numa design is not sufficient in kernel in following areas today:
> - Exposing memory attributes that describe heterogeneous memory system
> - Interfaces to use the heterogeneous memory system, e.g. more sophisticated policies
> - Internal mechanism in memory management, e.g. automigration, maybe something else.

Right, we would need

- Representation of NUMA with attributes
- APIs/syscalls for accessing the intended memory from user space
- Memory management policies and algorithms navigating trough all these
  new attributes in various situations

IMHO, we should not consider sysfs interfaces for heterogeneous memory
(which will be an ABI going forward and hence cannot be changed easily)
before we get the NUMA redesign right.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
