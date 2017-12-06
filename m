Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x243.google.com (mail-yw0-x243.google.com
 [IPv6:2607:f8b0:4002:c05::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4C7252217CE26
 for <linux-nvdimm@lists.01.org>; Wed,  6 Dec 2017 04:49:11 -0800 (PST)
Received: by mail-yw0-x243.google.com with SMTP id m129so1481171ywb.11
 for <linux-nvdimm@lists.01.org>; Wed, 06 Dec 2017 04:53:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171206003744.28587-2-ross.zwisler@linux.intel.com>
References: <20171206003744.28587-1-ross.zwisler@linux.intel.com>
 <20171206003744.28587-2-ross.zwisler@linux.intel.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 6 Dec 2017 14:53:41 +0200
Message-ID: <CAOQ4uxj1Y-qWU_9joBVEhzDwGOpmvBYK0Ew0D1Qh=xyEOW3ihw@mail.gmail.com>
Subject: Re: [fstests PATCH v5 1/2] dm-log-writes: only replay log to marks
 that exist
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 6, 2017 at 2:37 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> The 'replay-log' executable will replay the dm-log-writes log until the
> given mark, or until the end of the log if the mark isn't found.
>
> This means that if the mark you're looking for was never inserted in the
> log or if you give garbage to _log_writes_replay_log() the entire log will
> be replayed.  This can cause unexpected test results.
>
> Fix this by making sure that the mark we're given actually exists in the
> log before we allow the replay.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
Looks good.

Amir.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
