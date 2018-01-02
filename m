Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9ED7A2205BE9B
 for <linux-nvdimm@lists.01.org>; Tue,  2 Jan 2018 13:35:30 -0800 (PST)
Received: by mail-ot0-x241.google.com with SMTP id q39so38174386otb.8
 for <linux-nvdimm@lists.01.org>; Tue, 02 Jan 2018 13:40:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180102211539.GH4857@magnolia>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407702457.38751.9874209243918617373.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180102211539.GH4857@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 Jan 2018 13:40:32 -0800
Message-ID: <CAPcyv4hL4F0xDuFpWQ6ZEvtkMmhCa6V2oqr7bNFGeQQknNAf5w@mail.gmail.com>
Subject: Re: [PATCH v4 12/18] xfs: use DEFINE_FSDAX_AOPS
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 2, 2018 at 1:15 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Sat, Dec 23, 2017 at 04:57:04PM -0800, Dan Williams wrote:
>> In preparation for the dax implementation to start associating dax pages
>> to inodes via page->mapping, we need to provide a 'struct
>> address_space_operations' instance for dax. Otherwise, direct-I/O
>> triggers incorrect page cache assumptions and warnings.
>>
>> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
>> Cc: linux-xfs@vger.kernel.org
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  fs/xfs/xfs_aops.c |    2 ++
>>  fs/xfs/xfs_aops.h |    1 +
>>  fs/xfs/xfs_iops.c |    5 ++++-
>>  3 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
>> index 21e2d70884e1..361915d53cef 100644
>> --- a/fs/xfs/xfs_aops.c
>> +++ b/fs/xfs/xfs_aops.c
>> @@ -1492,3 +1492,5 @@ const struct address_space_operations xfs_address_space_operations = {
>>       .is_partially_uptodate  = block_is_partially_uptodate,
>>       .error_remove_page      = generic_error_remove_page,
>>  };
>> +
>> +DEFINE_FSDAX_AOPS(xfs_dax_address_space_operations, xfs_vm_writepages);
>
> Hmm, if we ever re-enable changing the DAX flag on the fly, will
> mapping->a_ops have to change dynamically too?
>
> How sure are we that we'll never have to set anything in the dax aops
> other than ->writepages?
>
> (I also kinda wonder why not just make the callers savvy vs. a bunch of
> dummy aops, but maybe that's been tried in a previous iteration?)

Matthew had similar feedback. I pushed back that I think more IS_DAX
sprinkling increases the long term maintenance burden, but now that
you've independently asked for the same thing I'm not opposed to
changing my mind.

Either way this need to switch the address_space_operations, or
synchronize against in-flight address_space_operations is going to
complicate the "dynamic toggle the dax mode" feature.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
