Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E41DA1A1E31
 for <linux-nvdimm@lists.01.org>; Sat, 15 Oct 2016 08:49:48 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id y2so169659488oie.0
 for <linux-nvdimm@lists.01.org>; Sat, 15 Oct 2016 08:49:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161015153214.26783-1-colin.king@canonical.com>
References: <20161015153214.26783-1-colin.king@canonical.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 15 Oct 2016 08:49:47 -0700
Message-ID: <CAPcyv4jJ4PGgYR=r6AT9AzpeRO+pQ3txUbtFFKms_ZV7JtiRvQ@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: fix dereference on null devs on error exit path
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
To: Colin King <colin.king@canonical.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Oct 15, 2016 at 8:32 AM, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> If devs cannot be allocated then the error exit path jumps to
> a cleanup loop that iterates over a null array of devs which
> is incorrect.  Fix this by jumping instead to the end of the
> function where NULL is returned.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks, I've already applied a similar fix from Dan Carpenter.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
