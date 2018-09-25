Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7A2E621157426
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 08:30:19 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id o13-v6so24837724otl.4
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 08:30:18 -0700 (PDT)
MIME-Version: 1.0
References: <1537832042.7585.16.camel@intel.com>
 <20180925091900.GB21972@kroah.com>
In-Reply-To: <20180925091900.GB21972@kroah.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 25 Sep 2018 08:30:06 -0700
Message-ID: <CAPcyv4jbP1yG+L9wUKTJhBgGV0_3e5pW8tB_Wfk6iT+ShB+qXQ@mail.gmail.com>
Subject: Re: [GIT PULL] libnvdimm/dax fixes for 4.19-rc6
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
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 25, 2018 at 2:22 AM gregkh@linuxfoundation.org
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Sep 24, 2018 at 11:34:04PM +0000, Williams, Dan J wrote:
> > Hi Greg, please pull from...
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes
>
> That isn't a signed tag.  Did you mean to not sign it?  Your previous
> pull requests did have signed tags :(

Ah, I have elided signed tags on small fixes branches on kernel.org
during -rc's. No worries, I'll resend signed.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
