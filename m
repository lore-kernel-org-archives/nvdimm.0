Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E01720945BA7
 for <linux-nvdimm@lists.01.org>; Wed, 11 Oct 2017 19:14:30 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id g125so6277473oib.12
 for <linux-nvdimm@lists.01.org>; Wed, 11 Oct 2017 19:18:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jr4atxCqFW_337Sguu8LswVgjsJVOd65n4RODttX9cxQ@mail.gmail.com>
References: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150776923838.9144.15727770472447035032.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171012012131.GD21978@ZenIV.linux.org.uk>
 <CAPcyv4jr4atxCqFW_337Sguu8LswVgjsJVOd65n4RODttX9cxQ@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Oct 2017 19:17:58 -0700
Message-ID: <CAPcyv4ij9E9tXPLqp6cUAY3dJzh7OS+yPsVDME50xSvQPLpStA@mail.gmail.com>
Subject: Re: [PATCH v9 2/6] fs, mm: pass fd to ->mmap_validate()
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
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 11, 2017 at 6:28 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, Oct 11, 2017 at 6:21 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> On Wed, Oct 11, 2017 at 05:47:18PM -0700, Dan Williams wrote:
>>> The MAP_DIRECT mechanism for mmap intends to use a file lease to prevent
>>> block map changes while the file is mapped. It requires the fd to setup
>>> an fasync_struct for signalling lease break events to the lease holder.
>>
>> *UGH*
>>
>> That looks like one hell of a bad API.  You are not even guaranteed that
>> descriptor will remain be still open by the time you pass it down to your
>> helper, nevermind the moment when event actually happens...
>
> What am I missing, fcntl(F_SETLEASE) seems to follow a similar pattern?

Ugh, so I think the difference with F_SETLEASE is that the lease ends
when the fd is closed. In the mmap case the lease follows the lifetime
of the vma. I'll rethink this interface...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
