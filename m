Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 55ED62194D387
 for <linux-nvdimm@lists.01.org>; Wed, 23 Jan 2019 09:09:04 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id c206so2430845oib.0
 for <linux-nvdimm@lists.01.org>; Wed, 23 Jan 2019 09:09:04 -0800 (PST)
MIME-Version: 1.0
References: <154777861562.42557.12388414625709189905.stgit@djiang5-desk3.ch.intel.com>
 <154777911312.42557.15688834797714631330.stgit@djiang5-desk3.ch.intel.com>
 <56a54d286cb2c7045478529e3ba34468fea3008f.camel@intel.com>
 <340b8cdd-bc30-73d2-627a-d3fcadc0c60a@intel.com>
In-Reply-To: <340b8cdd-bc30-73d2-627a-d3fcadc0c60a@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Jan 2019 09:08:48 -0800
Message-ID: <CAPcyv4jAu07jFjrnThH9cwWe-Bt22xBfoBAFAzRS7xNhiZHadw@mail.gmail.com>
Subject: Re: [PATCH v9 02/13] ndctl: add command for ndctl to receive the key
 encryption key (master)
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 18, 2019 at 1:12 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
>
>
> On 1/18/19 1:58 PM, Verma, Vishal L wrote:
> >
> > On Thu, 2019-01-17 at 19:38 -0700, Dave Jiang wrote:
> >> Add command that allows the user to provide the master encryption key name
> >> to be installed in the key material directory where ndctl can refer to
> >> for later security operations.
> >>
> >> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> >> ---
> >>  Documentation/ndctl/Makefile.am                   |    3
> >>  Documentation/ndctl/ndctl-install-encrypt-key.txt |   31 +++++
> >>  configure.ac                                      |    3
> >>  ndctl/Makefile.am                                 |    4 -
> >>  ndctl/builtin.h                                   |    1
> >>  ndctl/kek.c                                       |  133 +++++++++++++++++++++
> >>  ndctl/lib/libndctl.c                              |   31 +++++
> >>  ndctl/lib/libndctl.sym                            |    1
> >>  ndctl/lib/private.h                               |    1
> >>  ndctl/libndctl.h                                  |    1
> >>  ndctl/ndctl.c                                     |    1
> >>  11 files changed, 208 insertions(+), 2 deletions(-)
> >>  create mode 100644 Documentation/ndctl/ndctl-install-encrypt-key.txt
> >>  create mode 100644 ndctl/kek.c
> >>
> >> diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
> >> index a30b139b..7cb7bd6b 100644
> >> --- a/Documentation/ndctl/Makefile.am
> >> +++ b/Documentation/ndctl/Makefile.am
> >> @@ -47,7 +47,8 @@ man1_MANS = \
> >>      ndctl-inject-smart.1 \
> >>      ndctl-update-firmware.1 \
> >>      ndctl-list.1 \
> >> -    ndctl-monitor.1
> >> +    ndctl-monitor.1 \
> >> +    ndctl-install-encrypt-key.1
> >
> > I think Dan's feedback was to call this command setup-passphrase?
> > By 'install-encrypt-key' it seems unclear whether you mean "install
> > encrypted key" vs. "install a key and encrypt it"
> > Alternatively, the command can simply be 'install-kek', and the
> > synopsis/description can expand on what 'kek' is and how it is used.
>
> It probably should be called install encrypted key or install encryption
> key. The next patch has setup-passphrase. This isn't it.

True, but is it more: configure-key than install-key? All we're doing
at this point is recording the key details into a configuration file.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
