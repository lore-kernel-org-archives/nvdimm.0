Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB78181FC3
 for <linux-nvdimm@lists.01.org>; Sun,  4 Dec 2016 11:21:14 -0800 (PST)
Received: by mail-oi0-x22b.google.com with SMTP id w63so319197334oiw.0
 for <linux-nvdimm@lists.01.org>; Sun, 04 Dec 2016 11:21:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1480791212-21347-1-git-send-email-fabf@skynet.be>
References: <1480791212-21347-1-git-send-email-fabf@skynet.be>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 4 Dec 2016 11:21:13 -0800
Message-ID: <CAPcyv4hmPK4sRHoJ-eJCPvsu0sCO380Wm+t4b6cc6Z5+D6bkQQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/3 libnvdimm-pending] libnvdimm: remove else after
 return in nsio_rw_bytes()
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
To: Fabian Frederick <fabf@skynet.be>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Dec 3, 2016 at 10:53 AM, Fabian Frederick <fabf@skynet.be> wrote:
> else after return is not needed.
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> V2: -applied on top of libnvdimm-pending
>

Thanks. This one and the other 2 are applied and pushed out to
libnvdimm-pending.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
