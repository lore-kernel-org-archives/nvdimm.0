MIME-Version: 1.0
In-Reply-To: <20160518133422.6dfbad0b@canb.auug.org.au>
References: <1463510194.29294.77.camel@intel.com>
	<20160518133422.6dfbad0b@canb.auug.org.au>
Date: Tue, 17 May 2016 23:31:26 -0600
Message-ID: <CADDOmiLQAmOd8ADGSwtqd4WDKJmNT4CFu9veF0Z_emN9sqX3Mg@mail.gmail.com>
Subject: Re: dax-misc branch for linux-next
From: Vishal Verma <vishal@kernel.org>
Content-Type: multipart/alternative; boundary=94eb2c070d4c39e6620533172baa
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, hch@infradead.org, jack@suse.cz, linux-nvdimm@lists.01.org, tytso@mit.edu, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

--94eb2c070d4c39e6620533172baa
Content-Type: text/plain; charset=UTF-8

On Tue, May 17, 2016 at 9:34 PM, Stephen Rothwell <sfr@canb.auug.org.au>
wrote:

> Hi Vishal,
>
> On Tue, 17 May 2016 18:36:47 +0000 "Verma, Vishal L" <
> vishal.l.verma@intel.com> wrote:
> >
> > I understand this is a bit out of the norm, but:
> >
> > Could you please merge
> >
> >       https://git.kernel.org/cgit/linux/kernel/git/nvdimm/nvdimm.git
>  dax-misc
> >
> > into linux-next for some coverage.
> >
> > It is a bit late to the ready-before-merge-window deadline, due to
> > having to coordinate dependencies between trees/patchsets. I'm hoping to
> > send a pull request for this later in the merge window (once ext4 is
> > merged).
>
> Added from today.
>
> Thanks for adding your subsystem tree as a participant of linux-next.  As
> you may know, this is not a judgement of your code.  The purpose of
> linux-next is for integration testing and to lower the impact of
> conflicts between subsystems in the next merge window.
>
> You will need to ensure that the patches/commits in your tree/series have
> been:
>      * submitted under GPL v2 (or later) and include the Contributor's
>         Signed-off-by,
>      * posted to the relevant mailing list,
>      * reviewed by you (or another maintainer of your subsystem tree),
>      * successfully unit tested, and
>      * destined for the current or next Linux merge window.
>
> Basically, this should be just what you would send to Linus (or ask him
> to fetch).  It is allowed to be rebased if you deem it necessary.
>

Thanks for merging, Stephen, and also for resolving the conflicts. I meant
to post a branch with the example resolution for the nvdimm tree, but
somehow it completely slipped my mind.

--94eb2c070d4c39e6620533172baa
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On T=
ue, May 17, 2016 at 9:34 PM, Stephen Rothwell <span dir=3D"ltr">&lt;<a href=
=3D"mailto:sfr@canb.auug.org.au" target=3D"_blank">sfr@canb.auug.org.au</a>=
&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0=
 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div id=3D":12y" class=
=3D"a3s aXjCH m154c1efa7602d149">Hi Vishal,<br>
<span class=3D""><br>
On Tue, 17 May 2016 18:36:47 +0000 &quot;Verma, Vishal L&quot; &lt;<a href=
=3D"mailto:vishal.l.verma@intel.com">vishal.l.verma@intel.com</a>&gt; wrote=
:<br>
&gt;<br>
&gt; I understand this is a bit out of the norm, but:<br>
&gt;<br>
&gt; Could you please merge<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0<a href=3D"https://git.kernel.org/cgit/linux=
/kernel/git/nvdimm/nvdimm.git" rel=3D"noreferrer" target=3D"_blank">https:/=
/git.kernel.org/cgit/linux/kernel/git/nvdimm/nvdimm.git</a>=C2=A0dax-misc<b=
r>
&gt;<br>
&gt; into linux-next for some coverage.<br>
&gt;<br>
&gt; It is a bit late to the ready-before-merge-window deadline, due to<br>
&gt; having to coordinate dependencies between trees/patchsets. I&#39;m hop=
ing to<br>
&gt; send a pull request for this later in the merge window (once ext4 is<b=
r>
&gt; merged).<br>
<br>
</span>Added from today.<br>
<br>
Thanks for adding your subsystem tree as a participant of linux-next.=C2=A0=
 As<br>
you may know, this is not a judgement of your code.=C2=A0 The purpose of<br=
>
linux-next is for integration testing and to lower the impact of<br>
conflicts between subsystems in the next merge window.<br>
<br>
You will need to ensure that the patches/commits in your tree/series have<b=
r>
been:<br>
=C2=A0 =C2=A0 =C2=A0* submitted under GPL v2 (or later) and include the Con=
tributor&#39;s<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Signed-off-by,<br>
=C2=A0 =C2=A0 =C2=A0* posted to the relevant mailing list,<br>
=C2=A0 =C2=A0 =C2=A0* reviewed by you (or another maintainer of your subsys=
tem tree),<br>
=C2=A0 =C2=A0 =C2=A0* successfully unit tested, and<br>
=C2=A0 =C2=A0 =C2=A0* destined for the current or next Linux merge window.<=
br>
<br>
Basically, this should be just what you would send to Linus (or ask him<br>
to fetch).=C2=A0 It is allowed to be rebased if you deem it necessary.</div=
></blockquote></div><div class=3D"gmail_extra"><br></div>Thanks for merging=
, Stephen, and also for resolving the conflicts. I meant to post a branch w=
ith the example resolution for the nvdimm tree, but somehow it completely s=
lipped my mind.</div></div>

--94eb2c070d4c39e6620533172baa--
