Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7B0B220349D9F
 for <linux-nvdimm@lists.01.org>; Mon, 13 Nov 2017 15:45:05 -0800 (PST)
Subject: Re: [PATCH v2 1/2] ndctl: daxctl: fix mmap size
References: <151059717963.29832.3262165776997767425.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4jVW7fezh25ydzU2J1KgfeUrFMqzHj1WrsNH7OAbWEePw@mail.gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <c57f99fe-cfd0-af71-a608-8649c6e09546@intel.com>
Date: Mon, 13 Nov 2017 16:49:10 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jVW7fezh25ydzU2J1KgfeUrFMqzHj1WrsNH7OAbWEePw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 11/13/2017 04:40 PM, Dan Williams wrote:
> On Mon, Nov 13, 2017 at 10:19 AM, Dave Jiang <dave.jiang@intel.com> wrote:
>> The size for mmap needs to be aligned to the region alignment. Fix the
>> mapping size so that it satisfy the alignment requirement.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  daxctl/io.c |   12 +++++++++++-
>>  1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/daxctl/io.c b/daxctl/io.c
>> index 2f8cb4a..e739d0e 100644
>> --- a/daxctl/io.c
>> +++ b/daxctl/io.c
>> @@ -55,6 +55,7 @@ struct io_dev {
>>         struct ndctl_region *region;
>>         struct ndctl_dax *dax;
>>         uint64_t size;
>> +       uint64_t mmap_size;
>>  };
>>
>>  static struct {
>> @@ -83,6 +84,7 @@ static bool is_stdinout(struct io_dev *io_dev)
>>  static int setup_device(struct io_dev *io_dev, size_t size)
>>  {
>>         int flags, rc;
>> +       unsigned long align;
>>
>>         if (is_stdinout(io_dev))
>>                 return 0;
>> @@ -104,8 +106,14 @@ static int setup_device(struct io_dev *io_dev, size_t size)
>>         if (!io_dev->is_dax)
>>                 return 0;
>>
>> +       align = ndctl_dax_get_align(io_dev->dax);
>> +       if (align == ULLONG_MAX)
> 
> Isn't this always false because 'align' is 'unsigned long', not
> 'unsigned long long'?
> 
> Otherwise the rest of this looks good.
> 

Ok I'll send out v3 if you don't have issues with the other patch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
