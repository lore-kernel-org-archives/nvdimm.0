From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v2 01/14] kunit: test: add KUnit test runner core
Date: Tue, 6 Nov 2018 17:28:43 -0800
Message-ID: <CAFd5g45KNNGPVh4EBm8vKGdVhqajZZA0TU=CFbceJziYufb0Ug@mail.gmail.com>
References: <20181023235750.103146-1-brendanhiggins@google.com>
 <20181023235750.103146-2-brendanhiggins@google.com>
 <017b111f-d960-c1ef-46ae-eb0eb639fe5b@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <017b111f-d960-c1ef-46ae-eb0eb639fe5b-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: brakmo-b10kYP2dOMg@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, Tim.Bird-7U/KSKJipcs@public.gmane.org, Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Fri, Nov 2, 2018 at 11:44 AM Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On 10/23/2018 05:57 PM, Brendan Higgins wrote:
<snip>
> > + * Example:
> > + *
> > + * .. code-block:: c
> > + *
> > + *   void add_test_basic(struct test *test)
> > + *   {
> > + *           TEST_EXPECT_EQ(test, 1, add(1, 0));
> > + *           TEST_EXPECT_EQ(test, 2, add(1, 1));
> > + *           TEST_EXPECT_EQ(test, 0, add(-1, 1));
> > + *           TEST_EXPECT_EQ(test, INT_MAX, add(0, INT_MAX));
> > + *           TEST_EXPECT_EQ(test, -1, add(INT_MAX, INT_MIN));
> > + *   }
> > + *
> > + *   static struct test_case example_test_cases[] = {
> > + *           TEST_CASE(add_test_basic),
> > + *           {},
> > + *   };
> > + *
> > + */
> > +struct test_case {
> > +     void (*run_case)(struct test *test);
> > +     const char name[256];
> > +
> > +     /* private: internal use only. */
> > +     bool success;
> > +};
> > +
>
> Introducing a prefix kunit_* might be a good idea for the API.
> This comment applies to the rest of patches as well.

What about kunit_* instead of test_* and kmock_* instead of mock_*?
Does that seem reasonable?
