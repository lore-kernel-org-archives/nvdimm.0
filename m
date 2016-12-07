Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C2DAB81FCF
 for <linux-nvdimm@lists.01.org>; Tue,  6 Dec 2016 17:11:51 -0800 (PST)
Received: by mail-oi0-x22a.google.com with SMTP id y198so400461840oia.1
 for <linux-nvdimm@lists.01.org>; Tue, 06 Dec 2016 17:11:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.11.1612051648270.1536@eggly.anvils>
References: <147931721349.37471.4835899844582504197.stgit@dwillia2-desk3.amr.corp.intel.com>
 <alpine.LSU.2.11.1612051648270.1536@eggly.anvils>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Dec 2016 17:11:50 -0800
Message-ID: <CAPcyv4hp03_K1vMsf-=bxuKRYzX=ZMX+bcwnGwLbaoST_JwWjA@mail.gmail.com>
Subject: Re: [PATCH] device-dax: fail all private mapping attempts
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
To: Hugh Dickins <hughd@google.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Dec 5, 2016 at 5:01 PM, Hugh Dickins <hughd@google.com> wrote:
> On Wed, 16 Nov 2016, Dan Williams wrote:
>
>> The device-dax implementation originally tried to be tricky and allow
>> private read-only mappings, but in the process allowed writable
>> MAP_PRIVATE + MAP_NORESERVE mappings.  For simplicity and predictability
>> just fail all private mapping attempts since device-dax memory is
>> statically allocated and will never support overcommit.
>>
>> Cc: <stable@vger.kernel.org>
>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
>> Reported-by: Pawel Lebioda <pawel.lebioda@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/dax/dax.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
>> index 0e499bfca41c..3d94ff20fdca 100644
>> --- a/drivers/dax/dax.c
>> +++ b/drivers/dax/dax.c
>> @@ -270,8 +270,8 @@ static int check_vma(struct dax_dev *dax_dev, struct vm_area_struct *vma,
>>       if (!dax_dev->alive)
>>               return -ENXIO;
>>
>> -     /* prevent private / writable mappings from being established */
>> -     if ((vma->vm_flags & (VM_NORESERVE|VM_SHARED|VM_WRITE)) == VM_WRITE) {
>> +     /* prevent private mappings from being established */
>> +     if ((vma->vm_flags & VM_SHARED) != VM_SHARED) {
>
> I think that is more restrictive than you intended: haven't tried,
> but I believe it rejects a PROT_READ, MAP_SHARED, O_RDONLY fd mmap,
> leaving no way to mmap /dev/dax without write permission to it.
>
> See line 1393 of mm/mmap.c: the test you want is probably
>         if (!(vma->vm_flags & VM_MAYSHARE))
>

Yes, it is. Thank you!

Fix for the fix on the way...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
