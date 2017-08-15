Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BCF9D21DFC862
 for <linux-nvdimm@lists.01.org>; Tue, 15 Aug 2017 09:26:17 -0700 (PDT)
Received: from mail-it0-f45.google.com (mail-it0-f45.google.com
 [209.85.214.45])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id AE87722C9A
 for <linux-nvdimm@lists.01.org>; Tue, 15 Aug 2017 16:28:42 +0000 (UTC)
Received: by mail-it0-f45.google.com with SMTP id m34so6520798iti.1
 for <linux-nvdimm@lists.01.org>; Tue, 15 Aug 2017 09:28:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <150277753660.23945.11500026891611444016.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150277752553.23945.13932394738552748440.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150277753660.23945.11500026891611444016.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Tue, 15 Aug 2017 09:28:21 -0700
Message-ID: <CALCETrU811Ac+DpiUP8MdayA6cD3Jk+Dd0RXAqk5YM6Lj9YsDQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mm: introduce MAP_VALIDATE a mechanism for adding
 new mmap flags
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
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 14, 2017 at 11:12 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> The mmap syscall suffers from the ABI anti-pattern of not validating
> unknown flags. However, proposals like MAP_SYNC and MAP_DIRECT need a
> mechanism to define new behavior that is known to fail on older kernels
> without the feature. Use the fact that specifying MAP_SHARED and
> MAP_PRIVATE at the same time is invalid as a cute hack to allow a new
> set of validated flags to be introduced.

While this is cute, is it actually better than a new syscall?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
