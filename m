From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v4 08/17] kunit: test: add support for test abort
Date: Tue, 26 Mar 2019 08:44:41 +0100
Message-ID: <a23e4d7f85b0c0daec25bb06ed3c4a1d078401d4.camel@oracle.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <20190214213729.21702-9-brendanhiggins@google.com>
 <da1995fa-a362-dfe6-8184-7fcdf2b923e8@gmail.com>
 <CAFd5g467OV8wTB7zEshgZw8g8=zoq0dLVfwx3wDH-8UA+9GWFA@mail.gmail.com>
 <0124ed28-466c-e954-ddde-495419630a9f@gmail.com>
 <CAFd5g47EDmsBWKNiW0jpHW2VG_GWCfe8UO+=ofgM2_ru+_UBQA@mail.gmail.com>
 <118d89b7-d468-6d68-a48d-4d6d9cefd106@gmail.com>
 <CAFd5g46AP9yZQ+z+60HGaZuqhJQmfSBw9+r62w4k=cGiMEkqLA@mail.gmail.com>
 <e29d487f5ca0a5caf4723bc5d96b8a523a53a318.camel@oracle.com>
 <CAFd5g44eqjN-nVCJuoeYFCxwVa5AorWiAnXe-tFCAc11zDgJFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAFd5g44eqjN-nVCJuoeYFCxwVa5AorWiAnXe-tFCAc11zDgJFA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: brakmo-b10kYP2dOMg@public.gmane.org, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Bird,
 Timothy" <Tim.Bird-7U/KSKJipcs@public.gmane.org>, Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TZUIDd8j+nm9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Mon, 2019-03-25 at 15:32 -0700, Brendan Higgins wrote:
> On Fri, Mar 22, 2019 at 12:11 AM Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > On Thu, 2019-03-21 at 18:41 -0700, Brendan Higgins wrote:
> > > On Thu, Mar 21, 2019 at 6:10 PM Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > > > On 2/27/19 11:42 PM, Brendan Higgins wrote:
> > > > > On Tue, Feb 19, 2019 at 10:44 PM Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > > > wrote:
> > > > > > On 2/19/19 7:39 PM, Brendan Higgins wrote:
> > > > > > > On Mon, Feb 18, 2019 at 11:52 AM Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > > > > > wrote:
> > > > > > > > On 2/14/19 1:37 PM, Brendan Higgins wrote:
> < snip >
> > > > > > > > kunit_abort() is what will be call as the result of an assert
> > > > > > > > failure.
> > > > > > > 
> > > > > > > Yep. Does that need clarified somewhere.
> > > > > > > > BUG(), which is a panic, which is crashing the system is not
> > > > > > > > acceptable
> > > > > > > > in the Linux kernel.  You will just annoy Linus if you submit this.
> > > > > > > 
> > > > > > > Sorry, I thought this was an acceptable use case since, a) this should
> > > > > > > never be compiled in a production kernel, b) we are in a pretty bad,
> > > > > > > unpredictable state if we get here and keep going. I think you might
> > > > > > > have said elsewhere that you think "a" is not valid? In any case, I
> > > > > > > can replace this with a WARN, would that be acceptable?
> > > > > > 
> > > > > > A WARN may or may not make sense, depending on the context.  It may
> > > > > > be sufficient to simply report a test failure (as in the old version
> > > > > > of case (2) below.
> > > > > > 
> > > > > > Answers to "a)" and "b)":
> > > > > > 
> > > > > > a) it might be in a production kernel
> > > > > 
> > > > > Sorry for a possibly stupid question, how might it be so? Why would
> > > > > someone intentionally build unit tests into a production kernel?
> > > > 
> > > > People do things.  Just expect it.
> > > 
> > > Huh, alright. I will take your word for it then.
> > 
> > I have a better explanation: Production kernels have bugs, unfortunately.
> > And sometimes those need to be investigated on systems than cannot be
> > brought down or affected more than absolutely necessary, maybe via a third party
> > doing the execution. A light weight, precise test (well tested ahead :) ) might
> > be a way of proving or disproving assumptions that can lead to the development
> > and application of a fix.
> 
> Sorry, you are not suggesting testing in production are you? To be
> clear, I am not concerned about someone using testing, KUnit, or
> whatever in a *production-like* environment: that's not what we are
> talking about here. My assumption is that no one will deploy tests
> into actual production.

And my take is that you should not make such assumptions.
Even the cost of bringing down a "production-like" environment can be
significant, and the test infrastructure shouldn't think of itself as 
important enough to justify doing such things.

> > IMHO you're confusing "building into" with temporary applying, then removing
> > again - like the difference between running a local user space program vs
> > installing it under /usr and have it in everyone's PATH.
> 
> I don't really see the point of distinguishing between "building into"
> and "temporary applying" in this case; that's part of my point. Maybe
> it makes sense in whitebox end-to-end testing, but in the case of unit
> testing, I don't think so.
> 
> > > > > > a') it is not acceptable in my development kernel either
> > 
> > I think one of the fundamental properties of a good test framework is that it
> > should not require changes to the code under test by itself.
> > 
> 
> Sure, but that has nothing to do with the environment the code/tests
> are running in.

Well, just that if the tests require a special environment to run, 
you limit the usability of the tests in detecting or ruling out real issues.

Thanks,
Knut

> 
> < snip >
> 
> Cheers
