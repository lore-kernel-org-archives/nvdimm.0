Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x242.google.com (mail-lf0-x242.google.com
 [IPv6:2a00:1450:4010:c07::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2E929203B8CDB
 for <linux-nvdimm@lists.01.org>; Fri, 11 May 2018 09:39:16 -0700 (PDT)
Received: by mail-lf0-x242.google.com with SMTP id q2-v6so8771356lfc.12
 for <linux-nvdimm@lists.01.org>; Fri, 11 May 2018 09:39:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4i1=q45aqSHXkWvQQgXBqkwuHR2ZxXWmpbeQxptXCcAFA@mail.gmail.com>
References: <20180511163421.GA32728@jordon-HP-15-Notebook-PC>
 <CAPcyv4i1=q45aqSHXkWvQQgXBqkwuHR2ZxXWmpbeQxptXCcAFA@mail.gmail.com>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Fri, 11 May 2018 22:09:13 +0530
Message-ID: <CAFqt6zZitXMDzX7gX2xvMO1AzW7_RikgZ0ssRucYn6OWb3ON_w@mail.gmail.com>
Subject: Re: [PATCH v4] dax: Change return type to vm_fault_t
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Linux MM <linux-mm@kvack.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Huang," Ying" <ying.huang@intel.com>, Andrew Morton <akpm@linux-foundation.org>," zi.yan@cs.rutgers.edu, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 11, 2018 at 10:04 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Fri, May 11, 2018 at 9:34 AM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
>> Use new return type vm_fault_t for fault handler. For
>> now, this is just documenting that the function returns
>> a VM_FAULT value rather than an errno. Once all instances
>> are converted, vm_fault_t will become a distinct type.
>>
>> Commit 1c8f422059ae ("mm: change return type to vm_fault_t")
>>
>> Previously vm_insert_mixed() returns err which driver
>> mapped into VM_FAULT_* type. The new function
>> vmf_insert_mixed() will replace this inefficiency by
>> returning VM_FAULT_* type.
>>
>> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
>> Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
>> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> ---
>> v2: Modified the change log
>>
>> v3: Updated the change log and
>>     added Ross in review list
>>
>> v4: Addressed David's comment.
>>     Changes in huge_memory.c put
>>     together in a single patch that
>>     it is bisectable in furture
>
> Thanks, I'll carry this in the nvdimm tree since it collides with some
> work-in progress development.

Thanks Dan :)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
