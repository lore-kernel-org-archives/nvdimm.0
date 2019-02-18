Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3A7A321A07094
 for <linux-nvdimm@lists.01.org>; Mon, 18 Feb 2019 10:17:41 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id m1so29841412otf.5
 for <linux-nvdimm@lists.01.org>; Mon, 18 Feb 2019 10:17:41 -0800 (PST)
MIME-Version: 1.0
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
 <3eb67ffa-76c9-aa66-d162-d4e209330f48@gmail.com>
In-Reply-To: <3eb67ffa-76c9-aa66-d162-d4e209330f48@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Feb 2019 10:17:30 -0800
Message-ID: <CAPcyv4grMnrviSDJrA5FQOFvxuAMUXoKvgNpdy9sF9zi+OHJNA@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] The end of the DAX experiment
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
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Feb 17, 2019 at 12:29 PM Ric Wheeler <ricwheeler@gmail.com> wrote:
>
> On 2/6/19 4:12 PM, Dan Williams wrote:
> > Before people get too excited this isn't a proposal to kill DAX. The
> > topic proposal is a discussion to resolve lingering open questions
> > that currently motivate ext4 and xfs to scream "EXPERIMENTAL" when the
> > current DAX facilities are enabled. The are 2 primary concerns to
> > resolve. Enumerate the remaining features/fixes, and identify a path
> > to implement it all without regressing any existing application use
> > cases.
> >
> > An enumeration of remaining projects follows, please expand this list
> > if I missed something:
> >
> > * "DAX" has no specific meaning by itself, users have 2 use cases for
> > "DAX" capabilities: userspace cache management via MAP_SYNC, and page
> > cache avoidance where the latter aspect of DAX has no current api to
> > discover / use it. The project is to supplement MAP_SYNC with a
> > MAP_DIRECT facility and MADV_SYNC / MADV_DIRECT to indicate the same
> > dynamically via madvise. Similar to O_DIRECT, MAP_DIRECT would be an
> > application hint to avoid / minimiize page cache usage, but no strict
> > guarantee like what MAP_SYNC provides.
>
>
> Sounds like a great topic to me. Having just gone through a new round of USENIX
> paper reviews, it is interesting to see how many academic systems are being
> pitched in this space (and most of them don't mention the kernel based xfs/ext4
> with dax).

Makes sense, the current fsdax facility is chasing feature
deficiencies relative to device-dax (longterm pin support) and nova
(dax techniques for fs-metadata).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
