From: Kees Cook <keescook@google.com>
Subject: Re: [PATCH v2 12/17] kunit: tool: add Python wrappers for running
 KUnit tests
Date: Mon, 6 May 2019 10:43:55 -0700
Message-ID: <CAGXu5jJpp2HyEWMtAde+VUt=9ni3HRu69NM4rUQJu4kBrnx9Kw@mail.gmail.com>
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <20190501230126.229218-13-brendanhiggins@google.com> <20190502110220.GD12416@kroah.com>
 <CAFd5g47t=EdLKFCT=CnPkrM2z0nDVo24Gz4j0VxFOJbARP37Lg@mail.gmail.com>
 <a49c5088-a821-210c-66de-f422536f5b01@gmail.com> <CAFd5g44iWRchQKdJYtjRtPY6e-6e0eXpKXXsx5Ooi6sWE474KA@mail.gmail.com>
 <1a5f3c44-9fa9-d423-66bf-45255a90c468@gmail.com> <CAFd5g45RYm+zfdJXnyp2KZZH5ojfOzy++aq+4zBeE5VDu6WgEw@mail.gmail.com>
 <052fa196-4ea9-8384-79b7-fe6bacc0ee82@gmail.com> <CAFd5g47aY-CL+d7DfiyTidY4aAVY+eg1TM1UJ4nYqKSfHOi-0w@mail.gmail.com>
 <63f63c7c-6185-5e64-b338-6a5e7fb9e27c@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <63f63c7c-6185-5e64-b338-6a5e7fb9e27c@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Frank Rowand <frowand.list@gmail.com>, Brendan Higgins <brendanhiggins@google.com>, Shuah Khan <shuah@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Luis Chamberlain <mcgrof@kernel.org>, Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>, devicetree <devicetree@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, kunit-dev@googlegroups.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-um@lists.infradead.org, Sasha Levin <Alexander.Levin@microsoft.com>, "Bird, Timothy" <Tim.Bird@sony.com>, Amir
List-Id: linux-nvdimm@lists.01.org

On Sun, May 5, 2019 at 5:19 PM Frank Rowand <frowand.list@gmail.com> wrote:
> You can see the full version 14 document in the submitter's repo:
>
>   $ git clone https://github.com/isaacs/testanything.github.io.git
>   $ cd testanything.github.io
>   $ git checkout tap14
>   $ ls tap-version-14-specification.md
>
> My understanding is the the version 14 specification is not trying to
> add new features, but instead capture what is already implemented in
> the wild.

Oh! I didn't know about the work on TAP 14. I'll go read through this.

> > ## Here is what I propose for this patchset:
> >
> >  - Print out test number range at the beginning of each test suite.
> >  - Print out log lines as soon as they happen as diagnostics.
> >  - Print out the lines that state whether a test passes or fails as a
> > ok/not ok line.
> >
> > This would be technically conforming with TAP13 and is consistent with
> > what some kselftests have done.

This is what I fixed kselftest to actually do (it wasn't doing correct
TAP13), and Shuah is testing the series now:
https://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git/log/?h=ksft-tap-refactor

I'll go read TAP 14 now...

-- 
Kees Cook
