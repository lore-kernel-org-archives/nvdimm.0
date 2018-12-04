From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v3 16/19] arch: um: make UML unflatten device tree when
 testing
Date: Mon, 3 Dec 2018 16:00:50 -0800
Message-ID: <CAFd5g44vWXpY_N80UcAKVkgYQkBLP0qOV1=kwPyxcH4umOf8dg@mail.gmail.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-17-brendanhiggins@google.com>
 <CAL_JsqK5cG=QzMBFSZ31_-3ujnxqxv=jj3XYajbRLT7yWYZbfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAL_JsqK5cG=QzMBFSZ31_-3ujnxqxv=jj3XYajbRLT7yWYZbfw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: brakmo-b10kYP2dOMg@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, Tim.Bird-7U/KSKJipcs@public.gmane.org, Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Wed, Nov 28, 2018 at 1:16 PM Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Wed, Nov 28, 2018 at 1:38 PM Brendan Higgins
> <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
> > index a818ccef30ca2..bd58ae3bf4148 100644
> > --- a/arch/um/kernel/um_arch.c
> > +++ b/arch/um/kernel/um_arch.c
> > +#if IS_ENABLED(CONFIG_OF_UNITTEST)
> > +       unflatten_device_tree();
> > +#endif
>
> Kind of strange to have this in the arch code. I'd rather have this in
> the unittest code if possible. Can we have an initcall conditional on
> CONFIG_UM in the unittest do this? Side note, use a C if with
> IS_ENABLED() whenever possible instead of pre-processor #if.

Yeah, that makes more sense. I will send a separate patch.

>
> I'll take a fix separately as it was on my todo to fix. I've got the
> unit tests running in a gitlab CI job now[1].
>
> Rob
>
> [1] https://gitlab.com/robherring/linux-dt-unittest/pipelines
