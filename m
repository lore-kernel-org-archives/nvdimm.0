From: <Tim.Bird-7U/KSKJipcs@public.gmane.org>
Subject: RE: [PATCH v2 12/17] kunit: tool: add Python wrappers for running
 KUnit tests
Date: Tue, 7 May 2019 19:13:14 +0000
Message-ID: <ECADFF3FD767C149AD96A924E7EA6EAF9770AE37@USCULXMSG01.am.sony.com>
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <20190501230126.229218-13-brendanhiggins@google.com>
 <20190502110220.GD12416@kroah.com>
 <CAFd5g47t=EdLKFCT=CnPkrM2z0nDVo24Gz4j0VxFOJbARP37Lg@mail.gmail.com>
 <a49c5088-a821-210c-66de-f422536f5b01@gmail.com>
 <CAFd5g44iWRchQKdJYtjRtPY6e-6e0eXpKXXsx5Ooi6sWE474KA@mail.gmail.com>
 <1a5f3c44-9fa9-d423-66bf-45255a90c468@gmail.com>
 <CAFd5g45RYm+zfdJXnyp2KZZH5ojfOzy++aq+4zBeE5VDu6WgEw@mail.gmail.com>
 <052fa196-4ea9-8384-79b7-fe6bacc0ee82@gmail.com>
 <CAFd5g47aY-CL+d7DfiyTidY4aAVY+eg1TM1UJ4nYqKSfHOi-0w@mail.gmail.com>
 <63f63c7c-6185-5e64-b338-6a5e7fb9e27c@gmail.com>
 <CAFd5g46=ZU58uJ=Qhs3soBzJjzJKJFY0_uzZ7fe1CxPfJioNOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAFd5g46=ZU58uJ=Qhs3soBzJjzJKJFY0_uzZ7fe1CxPfJioNOA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: pmladek-IBi9RG/b67k@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, felixguoxiuping-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, julia.lawall-L2FTfq7BK8M@public.gmane.org, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Here is a bit of inline commentary on the TAP13/TAP14 discussion.

> -----Original Message-----
> From: Brendan Higgins 
> 
> > On 5/3/19 4:14 PM, Brendan Higgins wrote:
> > >> On 5/2/19 10:36 PM, Brendan Higgins wrote:
> > > In any case, it sounds like you and Greg are in agreement on the core
> > > libraries generating the output in TAP13, so I won't argue that point
> > > further.
> > >
> > > ## Analysis of using TAP13
> >
> > I have never looked at TAP version 13 in any depth at all, so do not consider
> > me to be any sort of expert.
> >
> > My entire TAP knowledge is based on:
> >
> >   https://testanything.org/tap-version-13-specification.html
> >
> > and the pull request to create the TAP version 14 specification:
> >
> >    https://github.com/TestAnything/testanything.github.io/pull/36/files
> >
> > You can see the full version 14 document in the submitter's repo:
> >
> >   $ git clone https://github.com/isaacs/testanything.github.io.git
> >   $ cd testanything.github.io
> >   $ git checkout tap14
> >   $ ls tap-version-14-specification.md
> >
> > My understanding is the the version 14 specification is not trying to
> > add new features, but instead capture what is already implemented in
> > the wild.
> >
> >
> > > One of my earlier concerns was that TAP13 is a bit over constrained
> > > for what I would like to output from the KUnit core. It only allows
> > > data to be output as either:
> > >  - test number
> > >  - ok/not ok with single line description
> > >  - directive
> > >  - diagnostics
> > >  - YAML block
> > >
> > > The test number must become before a set of ok/not ok lines, and does
> > > not contain any additional information. One annoying thing about this
> > > is it doesn't provide any kind of nesting or grouping.
> >
> > Greg's response mentions ktest (?) already does nesting.
> 
> I think we are talking about kselftest.
> 
> > Version 14 allows nesting through subtests.  I have not looked at what
> > ktest does, so I do not know if it uses subtest, or something else.
> 
> Oh nice! That is new in version 14. I can use that.

We have run into the problem of subtests (or nested tests, both using
TAP13) in Fuego.  I recall that this issue came up in kselftest, and I believe
we discussed a solution, but I don't recall what it was.

Can someone remind me what kselftest does to handle nested tests
(in terms of TAP13 output)?

> 
> > > There is one ok/not ok line per test and it may have a short
> > > description of the test immediately after 'ok' or 'not ok'; this is
> > > problematic because it wants the first thing you say about a test to
> > > be after you know whether it passes or not.
> >
> > I think you could output a diagnostic line that says a test is starting.
> > This is important to me because printk() errors and warnings that are
> > related to a test can be output by a subsystem other than the subsystem
> > that I am testing.  If there is no marker at the start of the test
> > then there is no way to attribute the printk()s to the test.
> 
> I agree.

This is a significant problem.  In Fuego we output each line with a test id prefix,
which goes against the spec, but helps solve this.  Test output should be
kept separate from system output, but if I understand correctly, there are no
channels in prinkt to use to keep different data streams separate.

How does kselftest deal with this now?

> 
> Technically conforms with the spec, and kselftest does that, but is
> also not part of the spec. Well, it *is* specified if you use
> subtests. I think the right approach is to make each
> "kunit_module/test suite" a test, and all the test cases will be
> subtests.
> 
> > > Directives are just a way to specify skipped tests and TODOs.
> > >
> > > Diagnostics seem useful, it looks like you can put whatever
> > > information in them and print them out at anytime. It looks like a lot
> > > of kselftests emit a lot of data this way.
> > >
> > > The YAML block seems to be the way that they prefer users to emit data
> > > beyond number of tests run and whether a test passed or failed. I
> > > could express most things I want to express in terms of YAML, but it
> > > is not the nicest format for displaying a lot of data like
> > > expectations, missed function calls, and other things which have a
> > > natural concise representation. Nevertheless, YAML readability is
> > > mostly a problem who won't be using the wrapper scripts.
> >
> > The examples in specification V13 and V14 look very simple and very
> > readable to me.  (And I am not a fan of YAML.)
> >
> >
> > > My biggest
> > > problem with the YAML block is that you can only have one, and TAP
> > > specifies that it must come after the corresponding ok/not ok line,
> > > which again has the issue that you have to hold on to a lot of
> > > diagnostic data longer than you ideally would. Another downside is
> > > that I now have to write a YAML serializer for the kernel.
> >
> > If a test generates diagnostic data, then I would expect that to be
> > the direct result of a test failure.  So the test can output the
> > "not ok" line, then immediately output the YAML block.  I do not
> > see a need for stashing YAML output ahead of time.
> >
> > If diagnostic data is generated before the test can determine
> > success or failure, then it can be output as diagnostic data
> > instead of stashing it for later.
> 
> Cool, that's what I am thinking I am going to do - I just wanted to
> make sure people were okay with this approach. I mean, I think that is
> what kselftest does.

IMHO the diagnostic data does not have to be in YAML.  That's only
if there's a well-known schema for the diagnostic data, to make the
data machine-readable.   TAP13 specifically avoided defining such a
schema.  I need to look at TAP14 and see if they have defined something.
(Thanks for bringing that to my attention.)

The important part, since there are no start and end delimiters for each
testcase, is to structure output (including from unrelated sub-systems
affected by the test) to either occur all before or all after the test line.
Otherwise it's impossible to sensibly parse the diagnostic data and associate it
with a test.  (That is, the TAP lines become the delimiters between each testcase's
output and data).  This is a pretty big weakness of TAP13.  Since the TAP line
has the test result, it usually means that the subsystem output for the test
is emitted *before* the TAP line.  It's preferable, in order to keep the
data together, that the diagnostic data also be emitted before the TAP
line.

> 
> We can hold off on the YAML stuff for now then.
> 
> > > ## Here is what I propose for this patchset:
> > >
> > >  - Print out test number range at the beginning of each test suite.
> > >  - Print out log lines as soon as they happen as diagnostics.
> > >  - Print out the lines that state whether a test passes or fails as a
> > > ok/not ok line.
> > >
> > > This would be technically conforming with TAP13 and is consistent with
> > > what some kselftests have done.
> > >
> > > ## To be done in a future patchset:
> > >
> > > Add a YAML serializer and print out some logs containing structured
> > > data (like expectation failures, unexpected function calls, etc) in
> > > YAML blocks.
> >
> > YAML serializer sounds like not needed complexity.
I agree, for now.

I think if we start to see some patterns for some data that many tests
output, we might want (as a kernel community) to define a YAML
schema for the kselftest output.  But I think that's biting off too much
right now.  IMHO we would want any YAML schema we define to
cover more than just unit tests, so the job of defining that would be
pretty big.

This would be a good discussion to have at a testing micro-conference
or summit. :-)

> >
> > >
> > > Does this sound reasonable? I will go ahead and start working on this,
> > > but feel free to give me feedback on the overall idea in the meantime.

Sounds good.  Thanks for working on this.
 -- Tim
