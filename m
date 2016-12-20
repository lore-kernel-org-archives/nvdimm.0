Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A4FDE821B9
 for <linux-nvdimm@lists.01.org>; Tue, 20 Dec 2016 12:09:46 -0800 (PST)
Received: by mail-oi0-x234.google.com with SMTP id 3so6735455oih.1
 for <linux-nvdimm@lists.01.org>; Tue, 20 Dec 2016 12:09:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161220075942.GB496@quack2.suse.cz>
References: <20161212164708.23244-1-jack@suse.cz>
 <20161213115209.GG15362@quack2.suse.cz>
 <CAPcyv4giLyY8pWP09V5BmUM+sfGO-VJCtkfV6L-RFS+0XQsT9Q@mail.gmail.com>
 <CAPcyv4jqN+GkO7pL0QE0vM50MmqPZ1aD2G3YmziKvp+4+oh5gQ@mail.gmail.com>
 <20161219095623.GE17598@quack2.suse.cz>
 <CAPcyv4jjLg=Nyxusz5Hp8OaJ9fi0Xf6LHW37jgVbxKoOYHjNQw@mail.gmail.com>
 <20161220075942.GB496@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 20 Dec 2016 12:09:45 -0800
Message-ID: <CAPcyv4gYeQ+ZjJZU07Co5OHvgPsdU4vmYPOfUyMxJTqmMRktnw@mail.gmail.com>
Subject: Re: [PATCH 0/6 v3] dax: Page invalidation fixes
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
To: Jan Kara <jack@suse.cz>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Dec 19, 2016 at 11:59 PM, Jan Kara <jack@suse.cz> wrote:
> On Mon 19-12-16 13:51:53, Dan Williams wrote:
[..]
> Yes, but I've accounted for that. Checking the libnvdimm-pending branch I
> see you missed "ext2: Return BH_New buffers for zeroed blocks" which was
> the first patch in the series. The subject is a slight misnomer since it is
> about setting IOMAP_F_NEW flag instead these days but still it is needed...
> Otherwise the DAX invalidation code would not propely invalidate zero pages
> in the radix tree in response to writes for ext2.

Ok, thanks. Updated libnvdimm-pending pushed out.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
